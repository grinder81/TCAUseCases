//
//  CollectionView.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-27.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct CollectionView: View {
    let store: Store<CollectionState, CollectionAction>
    
        var body: some View {
            WithViewStore(self.store) { viewStore in
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .lastTextBaseline) {
                        Text(viewStore.collection.title)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(.bottom, 2)
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: IfLetStore(
                                self.store.scope(
                                    state: { $0.verticalState },
                                    action: CollectionAction.collectionList
                                ),
                                then: CollectionListView.init(store:)
                            ),
                            isActive: viewStore.binding(
                                get: { $0.isNavigationActive },
                                send: CollectionAction.setNavigation(isActive:)
                            )
                        ) {
                            Text("See All".uppercased())
                                .font(.headline)
                        }
                        .padding(.trailing, 5)
                        
                    }
                    ScrollView (.horizontal) {
                        HStack(spacing: 10) {
                            ForEachStore(
                                self.store.scope(
                                    state: \.horizontalState,
                                    action: CollectionAction.presentable(id:action:)
                                ),
                                content: PresentableView.init(store:)
                            )
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.bottom, 20)
            }
        }
}
