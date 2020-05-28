//
//  CollectionCore.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation
import ComposableArchitecture

// Collection can present items in 2 ways:
// 1. Horizontal scroll view
// 2. List view or vertical scroll view

struct CollectionState: Equatable, Identifiable {
    var id: String { collection.id }
    
    var collection: CollectionType
    
    // API will provide it for exisitng record
    // and user can modify it
    var favorite: Set<UUID> = []
    
    // API will provide all items
    var items: IdentifiedArrayOf<PresentableItem> = []

    var isNavigationActive = false
}

extension CollectionState {
    // That's a horizontal presentation data
    var horizontalState: IdentifiedArrayOf<PresentableState> {
        get {
            let data = self.items.map{
                PresentableState(
                    isFavorite: self.favorite.contains($0.id),
                    item: $0
                )
            }
            return IdentifiedArrayOf(data)
        }
        set {
            let data = newValue.reduce([UUID]()) { (result, state) in
                var ids: [UUID] = result
                if state.isFavorite {
                    ids.append(state.id)
                }
                return ids
            }
            // Update by the new data
            self.favorite = Set(data)
        }
    }
    
    // That's vertical presentation data
    var verticalState: CollectionListState? {
        get {
            // If not in navigation then return nill
            guard self.isNavigationActive else {
                return nil
            }
            
            // Two item per row
            let chunded = self.items.chunked(into: 2)
            let rows = chunded.map{ $0.map {
                    PresentableState(
                        isFavorite: self.favorite.contains($0.id),
                        item: $0
                    )
                }
            }
            let data = rows.enumerated()
                .map {
                    RowState(
                        id: $0.offset,
                        items: IdentifiedArrayOf($0.element)
                    )
                }
            
            // List of rows which has 2 item per row
            return CollectionListState(
                collection: self.collection,
                rows: IdentifiedArrayOf(data)
            )
        }
        set {
            guard let value = newValue else {
                return
            }
            // If collection data changed it state then apply it here
            let data = value.rows
                .compactMap{ $0 }
                .compactMap{ $0.items }
                .reduce([UUID]()) { (result, array) in
                    var ids: [UUID] = result
                    let currentIds = array.reduce([UUID]()) { (result, state) in
                        var ids = result
                        if state.isFavorite {
                            ids.append(state.id)
                        }
                        return ids
                    }
                    ids += currentIds
                    return ids
            }
            self.favorite = Set(data)
        }
    }
}

enum CollectionAction {
    case setNavigation(isActive: Bool)
    
    // this is for vertical presentation
    case collectionList(CollectionListAction)
    
    // this is for horizontal presentation
    case presentable(id: UUID, action: PresentableAction)
}

let collectionReducer = Reducer<CollectionState, CollectionAction, Void>.combine(
    Reducer { state, action, _ in
        switch action {
        case .setNavigation(isActive: true):
            state.isNavigationActive = true
            
        case .setNavigation(isActive: false):
            state.isNavigationActive = false

        case .collectionList:
            break
            
        case .presentable:
            break
        }
        return .none
    },
    collectionListReducer.optional.pullback(
        state: \CollectionState.verticalState,
        action: /CollectionAction.collectionList,
        environment: {_ in Void()}
    ),
    presentableReducer.forEach(
        state: \CollectionState.horizontalState,
        action: /CollectionAction.presentable(id:action:),
        environment: { _ in Void() })
)
