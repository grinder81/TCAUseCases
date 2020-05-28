//
//  CollectionListView.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct CollectionListView: View {
    let store: Store<CollectionListState, CollectionListAction>
    
    var body: some View {
        ScrollView(.vertical) {
            ForEachStore(
                self.store.scope(
                    state: \.rows,
                    action: CollectionListAction.rows(id:action:)
                ),
                content: RowView.init(store:)
            )
        }
    }
}
