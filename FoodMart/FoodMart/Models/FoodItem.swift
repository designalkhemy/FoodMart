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
    let image_url: String
    
    var id: String { uuid }
    
}
