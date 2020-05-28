//
//  CollectionType.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation

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
    
    var id: String {
        return title
    }
}
