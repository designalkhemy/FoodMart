//
//  BasketItem.swift
//  FoodMart
//
//  Created by Jennifer on 2026-01-07.
//

import Foundation

struct BasketItem: Identifiable {
    var id: UUID = UUID()
    var foodItem: FoodItem
    var count: Int
}
