//
//  CollectionListCore.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation
import ComposableArchitecture

// List of rows presented in vertical direction
struct CollectionListState: Equatable {
    let collection: CollectionType
    var rows: IdentifiedArrayOf<RowState> = []
}

enum CollectionListAction {
    case rows(id: Int, action: RowAction)
}

let collectionListReducer = Reducer<CollectionListState, CollectionListAction, Void>.combine(
    rowReducer.forEach(
        state: \CollectionListState.rows,
        action: /CollectionListAction.rows(id:action:),
        environment: { _ in Void() }
    )
)

