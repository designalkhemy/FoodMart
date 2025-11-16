//
//  Category.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-16.
//

import Foundation

struct Category: Codable, Identifiable {
    
    let uuid: String
    let name: String
    
    var id: String { uuid }
    
    static let exampleCategory = Category(
        uuid: "b1f6d8a5-0e29-4d70-8d4f-1f8c1d7a5b12",
        name: "Produce"
    )
}
