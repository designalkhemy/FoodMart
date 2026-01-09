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
    
    enum SortBy {
        case name, price
    }
    
    @Observable @MainActor
    class ViewModel {
        private(set) var foodItems = [FoodItem]()
        private(set) var categories = [Category]()
        
        var searchText = ""
        
        private(set) var loadState = LoadState.loading
        
        var sortBy = SortBy.name
        
        var selectedCategories: Set<String> = []
        var showFilter = false
        
        var basketItems: [BasketItem] = []
        var showBasket = false
        
        var searchedFoodItems: [FoodItem] {
            if searchText.isEmpty {
                foodItems
            } else {
                foodItems.filter { $0.name.localizedStandardContains(searchText)}
            }
        }
        
        /// Array of food items that matches the selected categories, or
        /// all food items if no categories are selected
        var filteredFoodItems: [FoodItem] {
            guard !selectedCategories.isEmpty else { return searchedFoodItems }
            
            return searchedFoodItems.filter{ selectedCategories.contains($0.category_uuid) }
        }
        
        var sortedFoodItems: [FoodItem] {
            switch sortBy {
            case .price:
                return filteredFoodItems.sorted{ $0.price == $1.price ? $0.name < $1.name : $0.price < $1.price }
            default:
                return filteredFoodItems.sorted{ $0.name < $1.name }
            }
        }
        
        var totalAmount: Decimal {
            return basketItems.reduce(0) { $0 + $1.foodItem.price * Decimal($1.count) }
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
        
        func removeFromBasket(_ foodItem: FoodItem, _ removeAll: Bool) {
            if let index = basketItems.firstIndex(where: { $0.foodItem.uuid ==  foodItem.uuid}) {
                
                basketItems[index].count -= 1
                
                if basketItems[index].count == 0 || removeAll {
                    basketItems.remove(at: index)
                }
            }
        }
        
        func clearBasket() {
            basketItems.removeAll()
        }
        
        func clearFilter() {
            selectedCategories.removeAll()
        }
    }
}
