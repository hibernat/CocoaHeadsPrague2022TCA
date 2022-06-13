//
//  AppStore.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

//import Foundation
//import ComposableArchitecture
//
//typealias AppStore = Store<AppState, AppAction>
//typealias AppViewStore = ViewStore<AppState, AppAction>
//typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>
//
//struct AppState {
//
//}
//
//enum AppAction {
//    case onAppear
//    case binding(BindingAction<BindingFormState>)
//    case resetButtonTapped
//}
//
//struct AppEnvironment {
//    var date: () -> Date
//
//    var favorite: (UUID, Bool) -> Effect<Bool, Error>
//    var fetchNumber: () -> Effect<Int, Never>
//    var mainQueue: AnySchedulerOf<DispatchQueue>
//    var notificationCenter: NotificationCenter
//
//    static let live = Self(
//        date: Date.init,
//        downloadClient: .live,
//        fact: .live,
//        favorite: favorite(id:isFavorite:),
//        fetchNumber: liveFetchNumber,
//        mainQueue: .main,
//        notificationCenter: .default,
//        uuid: UUID.init,
//        webSocket: .live
//    )
//}
//
//let applicationReducer = Reducer<ApplicationState, ApplicationAction, ApplicationEnvironment>.combine(
//    .init { state, action, _ in
//        switch action {
//        case .onAppear:
//            state = .init()
//            return .none
//
//        default:
//            return .none
//        }
//    },
//
//)
//    .debug()
//    .signpost()
//
//private func liveFetchNumber() -> Effect<Int, Never> {
//    Deferred { Just(Int.random(in: 1...1_000)) }
//        .delay(for: 1, scheduler: DispatchQueue.main)
//        .eraseToEffect()
//}


