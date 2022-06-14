//
//  DetailStore.swift
//  TCADemo
//
//  Created by Michael Bernat on 14.06.2022.
//

import Foundation
import ComposableArchitecture

//MARK: - DetailState
struct DetailState: Equatable {
    @BindableState var sliderValue: Double
    var maxSlidersValue: Double
}

//MARK: - DetailAction
enum DetailAction: BindableAction {
    case binding(BindingAction<DetailState>)
}

//MARK: - DetailEnvironment
struct DetailEnvironment {
    
}

//MARK: - DetailState reducer
extension DetailState {
    
    static let reducer: Reducer<DetailState, DetailAction, DetailEnvironment> = .init { state, action, environment in
        
        return .none
        
    }
    .binding()
    
}

