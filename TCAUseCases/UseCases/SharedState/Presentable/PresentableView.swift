//
//  PresentableView.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct PresentableView: View {
    let store: Store<PresentableState, PresentableAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Button(action: {
                viewStore.send(.toggleItem)
            }) {
                VStack {
                    Text(viewStore.item.title)
                        .frame(width: 150, height: 150)
                }.background(viewStore.isFavorite ? Color.green : Color.yellow)
            }
        }
    }
}


