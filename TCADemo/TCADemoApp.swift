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
    
    let applicationStore: Store<ApplicationState, ApplicationAction> = .init(
        initialState: .init(),
        reducer: ApplicationState.reducer,
        environment: .init(
            mainQueue: .main,
            notificationCenter: .default,
            userDidTakeScreenshotNotification: UIApplication.userDidTakeScreenshotNotification
        )
    )
    
    var body: some Scene {
        WindowGroup {
            WithViewStore(applicationStore) { viewStore in
                RootView(
                    store: applicationStore
                        .scope(
                            state: \.rootState,
                            action: ApplicationAction.rootAction
                        )
                )
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}
