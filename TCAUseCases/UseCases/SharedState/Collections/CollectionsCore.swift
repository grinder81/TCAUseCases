//
//  CollectionsCore.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct CollectionsState: Equatable {
    var sections: IdentifiedArrayOf<CollectionState> = []
}

enum CollectionsAction {
    case collection(id: String, action: CollectionAction)
}

let collectionsReducer = Reducer<CollectionsState, CollectionsAction, Void>.combine(
    collectionReducer.forEach(
        state: \CollectionsState.sections,
        action: /CollectionsAction.collection(id:action:),
        environment: { _ in Void() }
    )
).debug()



// MARK: - Data extension

extension PresentableItem {
    static var asPresentables: IdentifiedArrayOf<PresentableItem> {
        let data: [PresentableItem] = [
            .init(title: "One"),
            .init(title: "Two"),
            .init(title: "Three"),
            .init(title: "Four"),
            .init(title: "Five"),
            .init(title: "Six"),
            .init(title: "Seven"),
            .init(title: "Eight"),
            .init(title: "Nine"),
            .init(title: "Ten")
        ]
        return IdentifiedArrayOf(data)
    }
}

extension CollectionType {
    static var asCollections: IdentifiedArrayOf<CollectionState> {
        let data = CollectionType.allCases
            .map{
                CollectionState(
                    collection: $0,
                    favorite: [],
                    items: PresentableItem.asPresentables,
                    isNavigationActive: false
                )
            }
        return IdentifiedArrayOf(data)
    }
}

extension CollectionsState {
    static let real = CollectionsState(sections: CollectionType.asCollections)
}
