//
//  CollectionView.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-27.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Extension

extension IdentifiedArrayOf {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


// MARK: - Data Model

// Individual presentable item
struct PresentableItem: Equatable, Identifiable {
    let id = UUID()
    var title: String
}

enum CollectionType: Int, Hashable, CaseIterable {
    case one
    case two
    case three
    case four
    case five
}

extension CollectionType {
    var title: String {
        switch self {
        case .one:
            return "One"
        case .two:
            return "Two"
        case .three:
            return "Three"
        case .four:
            return "Four"
        case .five:
            return "Five"
        }
    }
}

// MARK: - All Collections

struct CollectionsState: Equatable {
    var sections: IdentifiedArrayOf<CollectionState> = []
}

enum CollectionsAction {
    case collection(id: UUID, action: CollectionAction)
}

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

// MARK: - Collection


// Collection can present items in 2 ways:
// 1. Horizontal scroll view
// 2. List view or vertical scroll view

struct CollectionState: Equatable, Identifiable {
    let id = UUID()
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
            let data = rows.map{ RowState(items: IdentifiedArrayOf($0) )}
            
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

// MARK: - List state

// List of rows presented in vertical direction
struct CollectionListState: Equatable, Identifiable {
    let id = UUID()
    let collection: CollectionType
    var rows: IdentifiedArrayOf<RowState> = []
}

enum CollectionListAction {
    case rows(id: UUID, action: RowAction)
}

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

// MARK: - Row state

// Each row contain number of elements. 2 or more in
// horizontal direction
struct RowState: Equatable, Identifiable {
    let id = UUID()
    var items: IdentifiedArrayOf<PresentableState> = []
}

enum RowAction {
    case presentable(id: UUID, action: PresentableAction)
}

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

// MARK: - Presentable

struct PresentableState: Equatable, Identifiable {
    var id: UUID { item.id }
    var isFavorite: Bool = false
    var item: PresentableItem
}

enum PresentableAction {
    case toggleItem
}

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


// MARK: - All Reducers

let presentableReducer = Reducer<PresentableState, PresentableAction, Void> { state, action, _ in
    switch action {
    case .toggleItem:
        state.isFavorite.toggle()
    }
    return .none
}

let rowReducer = Reducer<RowState, RowAction, Void>.combine(
    presentableReducer.forEach(
        state: \RowState.items,
        action: /RowAction.presentable(id:action:),
        environment: {_ in Void()}
    )
)

let collectionListReducer = Reducer<CollectionListState, CollectionListAction, Void>.combine(
    rowReducer.forEach(
        state: \CollectionListState.rows,
        action: /CollectionListAction.rows(id:action:),
        environment: { _ in Void() }
    )
)

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
