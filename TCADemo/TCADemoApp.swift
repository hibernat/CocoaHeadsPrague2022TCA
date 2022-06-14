//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import SwiftUI

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: .init(),
                    reducer: RootState.reducer,
                    environment: .live
                )
            )
        }
    }
}
