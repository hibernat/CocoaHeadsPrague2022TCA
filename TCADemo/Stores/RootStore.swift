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
    
    @BindableState var sliderValue: Double = Double(Self.defaultValue)
    @BindableState var stepperValue: Int = Self.defaultValue
    @BindableState var text = ""
}

//MARK: - RootAction
enum RootAction: BindableAction {
    case binding(BindingAction<RootState>)
    case resetButtonTapped
}

//MARK: - RootEnvironment
struct RootEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var notificationCenter: NotificationCenter
    
    static let live = Self(
        mainQueue: .main,
        notificationCenter: .default
    )
    
    static let preview = Self(
        mainQueue: .main,
        notificationCenter: .default
    )
}

//MARK: - RootState reducer
extension RootState {
    
    static let reducer: Reducer<RootState, RootAction, RootEnvironment> = .init { state, action, environment in
        
        switch action {
            
        case .binding:
            return .none
            
        case .resetButtonTapped:
            state = .init()
            return .none
        }
        
    }
    .binding()
    .debug()
    
}
