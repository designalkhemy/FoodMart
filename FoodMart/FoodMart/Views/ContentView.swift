//
//  ContentView.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var foodItems = [FoodItem]()
    @State private var categories = [Category]()
    
    var body: some View {
        
        NavigationStack {
            FoodItemsView(foodItems: foodItems, categories: categories)
                .padding()
        }
        .task(loadData)
        
    }
    
    func loadData() async {
        
        do {
            let foodItemsUrl = URL(string: "https://7shifts.github.io/mobile-takehome/api/food_items.json")!
            let (foodItemsData, _) = try await URLSession.shared.data(from: foodItemsUrl)
            let foodItemsDecoder = JSONDecoder()
            foodItems = try foodItemsDecoder.decode([FoodItem].self, from: foodItemsData)
            
            let categoriesUrl = URL(string: "https://7shifts.github.io/mobile-takehome/api/food_item_categories.json")!
            let (categoriesData, _) = try await URLSession.shared.data(from: categoriesUrl)
            let categoriesDecoder = JSONDecoder()
            categories = try categoriesDecoder.decode([Category].self, from: categoriesData)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

#Preview {
    ContentView()
}
