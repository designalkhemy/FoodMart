//
//  ViewModel.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-17.
//

import Foundation

extension ContentView {
    
    enum LoadState {
        case loading, loaded, failed
    }
    
    @Observable @MainActor
    class ViewModel {
        private(set) var foodItems = [FoodItem]()
        private(set) var categories = [Category]()
        
        private(set) var loadState = LoadState.loading
        
        var selectedCategories: Set<String> = []
        var showFilter = false
        
        var basketItems: [BasketItem] = []
        var showBasket = false
        
        /// Array of food items that matches the selected categories, or
        /// all food items if no categories are selected
        var filteredFoodItems: [FoodItem] {
            guard !selectedCategories.isEmpty else { return foodItems }
            
            return foodItems.filter{ selectedCategories.contains($0.category_uuid) }
        }
        
        
        func loadData() async {
            loadState = .loading
            
            /// Fetch both food items and categories
            do {
                let foodItemsUrl = URL(string: "https://7shifts.github.io/mobile-takehome/api/food_items.json")!
                let (foodItemsData, _) = try await URLSession.shared.data(from: foodItemsUrl)
                let foodItemsDecoder = JSONDecoder()
                foodItems = try foodItemsDecoder.decode([FoodItem].self, from: foodItemsData)
                
                let categoriesUrl = URL(string: "https://7shifts.github.io/mobile-takehome/api/food_item_categories.json")!
                let (categoriesData, _) = try await URLSession.shared.data(from: categoriesUrl)
                let categoriesDecoder = JSONDecoder()
                categories = try categoriesDecoder.decode([Category].self, from: categoriesData)
                
                loadState = .loaded
                loadFilter()
            } catch {
                print(error.localizedDescription)
                loadState = .failed
            }
            
        }
        
        func saveFilter() {
            if let encoded = try? JSONEncoder().encode(selectedCategories) {
                UserDefaults.standard.set(encoded, forKey: "selectedCategories")
            }
//            UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
        }
        
        func loadFilter() {
            if let savedData = UserDefaults.standard.data(forKey: "selectedCategories") {
                if let decoded = try? JSONDecoder().decode(Set<String>.self, from: savedData) {
                    selectedCategories = decoded
                    return
                }
            }
            selectedCategories = []
        }
        
        func addToBasket(_ foodItem: FoodItem) {
            if let index = basketItems.firstIndex(where: { $0.foodItem.uuid ==  foodItem.uuid}) {
                basketItems[index].count += 1
            } else {
                basketItems.append(BasketItem(foodItem: foodItem, count: 1))
            }
        }
        
    }
}
