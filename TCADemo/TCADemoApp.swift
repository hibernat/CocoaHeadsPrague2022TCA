//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCADemoApp: App {
    
    var applicationStore: Store<ApplicationState, ApplicationAction> = .init(
        initialState: .init(),
        reducer: ApplicationState.reducer,
        environment: .main
    )
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: applicationStore
                    .scope(
                        state: \.rootState,
                        action: ApplicationAction.rootAction
                    )
            )
        }
    }
}
