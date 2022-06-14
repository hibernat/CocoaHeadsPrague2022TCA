//
//  RootStore.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import Foundation
import ComposableArchitecture

//MARK: - RootState
struct RootState: Equatable {
    
    private static let defaultValue: Int = 5
    fileprivate static let getAnimalsCancellableId = 1
    fileprivate static let getAnimalsDebounceId = 1
    
    @BindableState var sliderValue: Double = Double(Self.defaultValue)
    @BindableState var stepperValue: Int = Self.defaultValue
    @BindableState var text = ""
    
    var animals: [Animal] = []
    var screenshotsCount: Int
    var maxSlidersValue: Double = Double(Self.defaultValue)
    var isDetailPresented: Bool { detailState != nil }
    
    // sub-states
    var _detailState: DetailState? = nil
    var detailState: DetailState? {
        get {
            var state = _detailState
            state?.maxSlidersValue = maxSlidersValue
            return state
        }
        set {
            _detailState = newValue
            guard let newValue = newValue else { return }
            maxSlidersValue = max(maxSlidersValue, newValue.sliderValue)
        }
    }
}

//MARK: - RootAction
enum RootAction: BindableAction {
    case detailAction(DetailAction)
    case binding(BindingAction<RootState>)
    case resetButtonTapped
    case getAnimals
    case getAnimalsDebounced
    case getAnimalsResponse(Result<[Animal], AnimalServiceError>)
    case setDetail(isPresented: Bool)
}

//MARK: - RootEnvironment
struct RootEnvironment {
    var animalService: AnimalServiceProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var notificationCenter: NotificationCenter
    
    static let live = Self(
        animalService: AnimalService(),
        mainQueue: .main,
        notificationCenter: .default
    )
    
    static let preview = Self(
        animalService: AnimalServicePreview(),
        mainQueue: .main,
        notificationCenter: .default
    )
}

//MARK: - RootState reducer
extension RootState {
    
    static let reducer: Reducer<RootState, RootAction, RootEnvironment> = .combine(
        
        DetailState.reducer
            .optional()
            .pullback(
                state: \.detailState,
                action: /RootAction.detailAction,
                environment: { rootEnvironment in DetailEnvironment() }
            ),
        
        .init { state, action, environment in
        
        switch action {
            
        case .detailAction:
            return .none
            
        case .binding(\.$stepperValue):
            state.sliderValue = Double(state.stepperValue)
            state.maxSlidersValue = max(state.maxSlidersValue, state.sliderValue)
            return Effect(value: .getAnimals)
        
        case .binding(\.$sliderValue):
            state.stepperValue = Int(state.sliderValue)
            state.maxSlidersValue = max(state.maxSlidersValue, state.sliderValue)
            return Effect(value: .getAnimalsDebounced)
        
        case .binding(\.$text):
            guard let value = Int(state.text),
                  value > 0, value <= 10
            else { return .none }
            state.sliderValue = Double(value)
            state.maxSlidersValue = max(state.maxSlidersValue, state.sliderValue)
            state.stepperValue = value
            return Effect(value: .getAnimals)

        case .binding:
            return .none
            
        case .resetButtonTapped:
            state = .init(screenshotsCount: state.screenshotsCount)
            return Effect(value: .getAnimals)
            
        case .getAnimals:
            return environment.animalService
                .getAnimals(count: state.stepperValue)
                .catchToEffect()
                .map { RootAction.getAnimalsResponse($0) }
                .receive(on: environment.mainQueue)
                .eraseToEffect()
                .cancellable(id: RootState.getAnimalsCancellableId, cancelInFlight: true)
            
        case .getAnimalsDebounced:
            return Effect(value: .getAnimals)
                .debounce(
                    id: Self.getAnimalsDebounceId,
                    for: .seconds(2),
                    scheduler: environment.mainQueue
                )
            
        case .getAnimalsResponse(let result):
            switch result {
            case .failure(let animalServiceError):
                break
            case .success(let animals):
                state.animals = animals
            }
            return .none
            
        case .setDetail(let isPresented):
            if isPresented {
                state.detailState = .init(sliderValue: state.maxSlidersValue, maxSlidersValue: state.maxSlidersValue)
            } else {
                state.detailState = nil
            }
            return .none
            
        }
    }
    .binding()
    //.debug()
    )
    
}
