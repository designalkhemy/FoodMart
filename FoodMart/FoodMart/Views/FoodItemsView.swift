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
    
    @Binding var basketItems: [BasketItem]
    
    var categoryLookup: [String : String] {
        Dictionary(uniqueKeysWithValues: categories.map { ($0.uuid, $0.name)})
    }
    
    var addToBasket: (FoodItem) -> Void
    
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
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(.rect(cornerRadius: 10))
                        
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text("$\(foodItem.price.formatted(.number))")
                                    .font(.title2)
                                
                                Text(foodItem.name)
                                
                                Text(categoryLookup[foodItem.category_uuid] ?? "Unknown")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            
                            Button {
                                addToBasket(foodItem)
                            } label: {
                                Label("Add to basket", systemImage: "plus.circle")
                                    .font(.title)
                            }
                            .labelStyle(.iconOnly)
                            
                        }
                        
                        
                    }
                    .padding(5)
                }
            }
        }
    }
}

#Preview {
    FoodItemsView(foodItems: [.example], categories: [.exampleCategory], basketItems: .constant([BasketItem(foodItem: .example, count: 1)])) { _ in
        // do nothing
    }
}
