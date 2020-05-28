//
//  RowView.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct RowView: View {
    let store: Store<RowState, RowAction>
    
    var body: some View {
        HStack {
            ForEachStore(
                self.store.scope(
                    state: \.items,
                    action: RowAction.presentable(id:action:)
                ),
                content: PresentableView.init(store:)
            )
        }.padding()
    }
}
