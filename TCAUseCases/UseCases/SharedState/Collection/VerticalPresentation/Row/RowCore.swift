//
//  RowCore.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation
import ComposableArchitecture

// Each row contain number of elements. 2 or more in
// horizontal direction
struct RowState: Equatable, Identifiable {
    var id: Int
    var items: IdentifiedArrayOf<PresentableState> = []
}

enum RowAction {
    case presentable(id: UUID, action: PresentableAction)
}

let rowReducer = Reducer<RowState, RowAction, Void>.combine(
    presentableReducer.forEach(
        state: \RowState.items,
        action: /RowAction.presentable(id:action:),
        environment: {_ in Void()}
    )
)


