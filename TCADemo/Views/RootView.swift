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
        WithViewStore(store) { viewStore in
            Form {
                Section(header: Text("CocoaHeads Prague June 2022")) {
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
                    ForEach(viewStore.animals) { animal in
                        Text(animal.name)
                    }
                }
            }
            // this is new
            .onAppear {
                viewStore.send(.getAnimals)
            }
            // new ends here
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(),
                reducer: RootState.reducer,
                environment: .preview
            )
        )
    }
}
