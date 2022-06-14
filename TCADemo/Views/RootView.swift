//
//  RootView.swift
//  TCADemo
//
//  Created by Michael Bernat on 12.06.2022.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: Store<RootState, RootAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                Form {
                    Section(header: Text("CocoaHeads Prague June 2022")) {
                        Text("Max sliders value: \(Int(viewStore.maxSlidersValue))")
                        Text("Screenshots count: \(viewStore.screenshotsCount)")
                        TextField("Type here", text: viewStore.binding(\.$text))
                        Stepper(value: viewStore.binding(\.$stepperValue), in: 1...10) {
                            Text("Stepper value: \(viewStore.stepperValue)")
                        }
                        VStack(alignment: .leading) {
                            Text("Slider value: \(Int(viewStore.sliderValue))")
                            HStack {
                                Text("1")
                                Slider(value: viewStore.binding(\.$sliderValue), in: 1...10)
                                Text("10")
                            }
                        }
                        Button("Reset") {
                            viewStore.send(.resetButtonTapped)
                        }
                        .foregroundColor(.red)
                        Button("GetAnimals") {
                            viewStore.send(.getAnimals)
                        }
                        // this is new
                        Button {
                            viewStore.send(.setDetail(isPresented: true))
                        } label :{
                            Text("Show detail")
                        }
                        // new ends here
                        ForEach(viewStore.animals) { animal in
                            Text(animal.name)
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.getAnimals)
                }
                // this is new
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.isDetailPresented,
                        send: RootAction.setDetail(isPresented:)
                    )
                ) {
                    IfLetStore(
                        store.scope(
                            state: \.detailState,
                            action: RootAction.detailAction
                        ),
                        then: DetailView.init(store:)
                    )
                }
                // new ends here
                .navigationBarTitle("Demo")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(screenshotsCount: 0),
                reducer: RootState.reducer,
                environment: .preview
            )
        )
    }
}
