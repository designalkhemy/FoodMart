//
//  FoodItemsView.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-16.
//

import SwiftUI

struct FoodItemsView: View {
    
    let foodItems: [FoodItem]
    let categories: [Category]
    
    var categoryLookup: [String : String] {
        Dictionary(uniqueKeysWithValues: categories.map { ($0.uuid, $0.name)})
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(foodItems) { foodItem in
                    
                    VStack(alignment: .leading) {
                        FoodItemImage(imageURL: foodItem.image_url)
                            .clipShape(.rect(cornerRadius: 10))
                        
                        Text("$\(foodItem.price.formatted(.number))")
                            .font(.title2)
                        
                        Text(foodItem.name)
                            
                        Text(categoryLookup[foodItem.category_uuid] ?? "Unknown")
                            .font(.footnote)
                    }
                    .padding(5)
                }
            }
        }
    }
}

#Preview {
    FoodItemsView(foodItems: [.example], categories: [.exampleCategory])
}
