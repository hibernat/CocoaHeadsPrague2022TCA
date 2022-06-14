//
//  ApplicationStore.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import Foundation
import ComposableArchitecture

//MARK: - RootState
struct RootState: Equatable {
    
    private static let defaultValue: Int = 5
    static let getAnimalsCancellableId = 1
    
    @BindableState var sliderValue: Double = Double(Self.defaultValue)
    @BindableState var stepperValue: Int = Self.defaultValue
    @BindableState var text = ""
    
    var animals: [Animal] = []
}

//MARK: - RootAction
enum RootAction: BindableAction {
    case binding(BindingAction<RootState>)
    case resetButtonTapped
    case getAnimals
    case getAnimalsResponse(Result<[Animal], AnimalServiceError>)
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
    
    static let reducer: Reducer<RootState, RootAction, RootEnvironment> = .init { state, action, environment in
        
        switch action {
            
        case .binding(\.$stepperValue):
            state.sliderValue = Double(state.stepperValue)
            return Effect(value: .getAnimals)
        
        case .binding(\.$sliderValue):
            state.stepperValue = Int(state.sliderValue)
            return Effect(value: .getAnimals)
        
        case .binding(\.$text):
            guard let value = Int(state.text),
                  value > 0, value <= 10
            else { return .none }
            state.sliderValue = Double(value)
            state.stepperValue = value
            return Effect(value: .getAnimals)

        case .binding:
            return .none
            
        case .resetButtonTapped:
            state = .init()
            return Effect(value: .getAnimals)
            
        case .getAnimals:
            return environment.animalService
                .getAnimals(count: state.stepperValue)
                .catchToEffect()
                .map { RootAction.getAnimalsResponse($0) }
                .receive(on: environment.mainQueue)
                .eraseToEffect()
                .cancellable(id: RootState.getAnimalsCancellableId, cancelInFlight: true)
            
        case .getAnimalsResponse(let result):
            switch result {
            case .failure(let animalServiceError):
                break
            case .success(let animals):
                state.animals = animals
            }
            return .none

        }
    }
    .binding()
    .debug()
    
}
