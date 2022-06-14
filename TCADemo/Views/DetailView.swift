//
//  DetailView.swift
//  TCADemo
//
//  Created by Michael Bernat on 14.06.2022.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    
    let store: Store<DetailState, DetailAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Text("Max sliders value: \(Int(viewStore.maxSlidersValue))")
                VStack(alignment: .leading) {
                    Text("Slider value: \(Int(viewStore.sliderValue))")
                    HStack {
                        Text("1")
                        Slider(value: viewStore.binding(\.$sliderValue), in: 1...100)
                        Text("100")
                    }
                }
            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            store: .init(
                initialState: .init(sliderValue: 50, maxSlidersValue: 61),
                reducer: DetailState.reducer,
                environment: .init()
            )
        )
    }
}
