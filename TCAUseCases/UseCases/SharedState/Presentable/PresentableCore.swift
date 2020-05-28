//
//  PresentableCore.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct PresentableState: Equatable, Identifiable {
    var id: UUID { item.id }
    var isFavorite: Bool = false
    var item: PresentableItem
}

enum PresentableAction {
    case toggleItem
}

let presentableReducer = Reducer<PresentableState, PresentableAction, Void> { state, action, _ in
    switch action {
    case .toggleItem:
        state.isFavorite.toggle()
    }
    return .none
}
