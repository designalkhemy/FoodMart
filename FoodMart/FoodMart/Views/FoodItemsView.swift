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
                        AsyncImage(url: foodItem.image_url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(.rect(cornerRadius: 10))
                            default:
                                Rectangle()
                                    .fill(.gray)
                                    .aspectRatio(1, contentMode: .fill)
                                    
                            }
                            
                        }
                        
                        Text("$\(foodItem.price.formatted(.number))")
                            .font(.title2)
                        
                        Text(foodItem.name)
                            
                        Text(categoryLookup[foodItem.category_uuid] ?? "Unknown")
                            .font(.footnote)
                    }
                    .padding(10)
                }
            }
        }
    }
}

#Preview {
    FoodItemsView(foodItems: [.example, .example], categories: [.exampleCategory])
}
