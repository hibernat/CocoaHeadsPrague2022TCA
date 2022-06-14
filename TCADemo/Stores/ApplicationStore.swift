//
//  ApplicationStore.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import Foundation
import ComposableArchitecture

//MARK: - ApplicationState
struct ApplicationState: Equatable {
    
    private static let screenshotsCountDefaultValue: Int = 0
    
    var screenshotsCount = Self.screenshotsCountDefaultValue
    // sub-states
    var rootState = RootState(screenshotsCount: Self.screenshotsCountDefaultValue)
}

//MARK: - ApplicationAction
enum ApplicationAction {
    case rootAction(RootAction)
    case onAppear
    case userDidTakeScreenshotNotification
}

//MARK: - ApplicationEnvironment
struct ApplicationEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let notificationCenter: NotificationCenter
    let userDidTakeScreenshotNotification: NSNotification.Name
}

//MARK: - ApplicationState reducer
extension ApplicationState {
    
    static let reducer = Reducer<ApplicationState, ApplicationAction, ApplicationEnvironment>.combine(
        RootState.reducer
            .pullback(
                state: \.rootState,
                action: /ApplicationAction.rootAction,
                environment: { applicationEnvironment in
                    RootEnvironment(
                        animalService: AnimalService(),
                        mainQueue: applicationEnvironment.mainQueue,
                        notificationCenter: applicationEnvironment.notificationCenter
                    )
                }
            ),
        .init { state, action, environment in
            switch action {
            
            case .rootAction:
                return .none
                
            case .onAppear:
                return environment.notificationCenter
                    .publisher(for: environment.userDidTakeScreenshotNotification)
                    .eraseToEffect { _ in ApplicationAction.userDidTakeScreenshotNotification }
                    // should be assigned cancellable id, but not needed at app level
            
            case .userDidTakeScreenshotNotification:
                state.screenshotsCount += 1
                print("screenshotsCount value: \(state.screenshotsCount)")
                return .none
            }
        }
    )
    
}
