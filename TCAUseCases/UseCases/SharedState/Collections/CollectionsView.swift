//
//  CollectionsView.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CollectionsView: View {
    let store: Store<CollectionsState, CollectionsAction>
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEachStore(
                    self.store.scope(
                        state: \.sections,
                        action: CollectionsAction.collection(id:action:)
                    ),
                    content: CollectionView.init(store:)
                )
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
