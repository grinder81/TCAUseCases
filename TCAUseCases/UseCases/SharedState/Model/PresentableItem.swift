//
//  PresentableItem.swift
//  TCAUseCases
//
//  Created by MD AL MAMUN on 2020-05-28.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import Foundation

// Individual presentable item
struct PresentableItem: Equatable, Identifiable {
    let id = UUID()
    var title: String
}

