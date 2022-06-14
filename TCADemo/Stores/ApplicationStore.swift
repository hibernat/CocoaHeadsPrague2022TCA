//
//  ApplicationStore.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import Foundation
import ComposableArchitecture

//MARK: - ApplicationState
struct ApplicationState {
    var rootState = RootState()
}

//MARK: - ApplicationAction
enum ApplicationAction {
    case rootAction(RootAction)
}

//MARK: - ApplicationEnvironment
struct ApplicationEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var notificationCenter: NotificationCenter

    static let main = Self(
        mainQueue: .main,
        notificationCenter: .default
    )
    
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
            }
        }
    )
    
}
