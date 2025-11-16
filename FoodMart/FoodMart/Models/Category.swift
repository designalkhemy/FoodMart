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
}
