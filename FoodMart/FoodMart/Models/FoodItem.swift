//
//  FoodItem.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-16.
//

import Foundation

struct FoodItem: Codable, Identifiable {
    
    let uuid: String
    let name: String
    let price: Decimal
    let category_uuid: String
    let image_url: URL
    
    var id: String { uuid }
    
    static let example = FoodItem(
        uuid: "a1f7b3e5-4c1d-42e9-8f2a-8cbb8b1f6f01",
        name: "Bananas",
        price: 1.49,
        category_uuid: "b1f6d8a5-0e29-4d70-8d4f-1f8c1d7a5b12",
        image_url: URL(string: "https://7shifts.github.io/mobile-takehome/images/bananas.png")!
    )
    
}
