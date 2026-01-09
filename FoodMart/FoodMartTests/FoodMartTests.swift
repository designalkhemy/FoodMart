//
//  FoodMartTests.swift
//  FoodMartTests
//
//  Created by Jennifer on 2025-11-16.
//

@testable import FoodMart
import Foundation
import Testing

@MainActor
struct FoodMartTests {

    @Test func viewModelStartsEmpty() async throws {
        let viewModel = ContentView.ViewModel()
        
        #expect(viewModel.foodItems.isEmpty, "There should be no food items initially.")
        #expect(viewModel.categories.isEmpty, "There should be no categories initially.")
        #expect(viewModel.loadState == .loading, "The view model should start in a loading state.")
    }
    
    @Test func viewModelLoadsData() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        #expect(viewModel.foodItems.isEmpty == false, "There should be food items after loading.")
        #expect(viewModel.categories.isEmpty == false, "There should be categories after loading.")
        #expect(viewModel.loadState == .loaded, "The view model should finish in the loaded state.")
    }
    
    @Test func viewModelFilteringEmpty() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        #expect(viewModel.foodItems.count == viewModel.filteredFoodItems.count, "No filtered categories should show all food items.")
    }
    
    @Test func viewModelFilteringSingleCategory() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstCategory = viewModel.categories.first!
        viewModel.selectedCategories.insert(firstCategory.uuid)
        
        for item in viewModel.filteredFoodItems {
            #expect(item.category_uuid == firstCategory.uuid, "Filtered food items should all belong to the selected category.")
        }
    }
    
    @Test func viewModelFilteringMultipleCategories() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstCategory = viewModel.categories.first!
        let secondCategory = viewModel.categories.last!
        viewModel.selectedCategories.insert(firstCategory.uuid)
        viewModel.selectedCategories.insert(secondCategory.uuid)
        
        for item in viewModel.filteredFoodItems {
            #expect(viewModel.selectedCategories.contains(item.category_uuid), "Filtered food items should belong to one of the selected categories.")
        }
    }
    
    @Test func viewModelAllCategoriesSelected() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        viewModel.selectedCategories = Set(viewModel.categories.map(\.uuid))
        
        #expect(viewModel.selectedCategories.count == viewModel.categories.count, "All categories should be selected.")
        #expect(viewModel.filteredFoodItems.count == viewModel.foodItems.count, "Filtered food items should match the total when all categories are selected.")
    }
    
    @Test func vieModelClearCategoriesSelectedButton() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstCategory = viewModel.categories.first!
        let secondCategory = viewModel.categories.last!
        viewModel.selectedCategories.insert(firstCategory.uuid)
        viewModel.selectedCategories.insert(secondCategory.uuid)
        
        viewModel.clearFilter()
        #expect(viewModel.selectedCategories.isEmpty, "Selected categories should be empty after clearing.")
    }
    
    @Test func viewModelSearchExact() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        viewModel.searchText = viewModel.foodItems.first?.name ?? ""
        
        #expect(viewModel.searchedFoodItems.count == 1, "Searching for an exact food item should only show 1 result.")
    }
    
    @Test func viewModelSearchEmpty() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        viewModel.searchText = "NOT A FOOD ITEM"
        
        #expect(viewModel.searchedFoodItems.isEmpty, "With an impossible food item, no food items should be shown.")
    }
    
    @Test func viewModelSortByName() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        viewModel.sortBy = .name
        
        let sortedFoodItems = viewModel.sortedFoodItems
        
        for i in 0..<(sortedFoodItems.count) {
            #expect(sortedFoodItems[i].name < sortedFoodItems[i+1].name, "When sorting by name, food items should be sorted alphabetically.")
        }
        
    }
    
    @Test func viewModelSortByPrice() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        viewModel.sortBy = .price
        
        let sortedFoodItems = viewModel.sortedFoodItems
        
        for i in 0..<(sortedFoodItems.count) {
            #expect(sortedFoodItems[i].price <= sortedFoodItems[i+1].price, "When sorting by price, food items should be sorted from lowest to highest.")
            if sortedFoodItems[i].price == sortedFoodItems[i+1].price {
                #expect(sortedFoodItems[i].name < sortedFoodItems[i+1].name, "If 2 food items have the same price, they should still be sorted by name.")
            }
        }
    }
    
    @Test func viewModelBasketStartsEmpty() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        #expect(viewModel.basketItems.isEmpty, "The basket should be initially empty.")
        #expect(viewModel.totalAmount == 0, "Total amount should be 0 when basket is empty.")
    }
    
    @Test func viewModelAddItemToEmptyBasket() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstItem = viewModel.foodItems.first!
        viewModel.addToBasket(firstItem)
        
        #expect(viewModel.basketItems.count == 1, "Basket should have 1 item.")
        #expect(viewModel.totalAmount == firstItem.price, "Total amount should equal the price of the added item.")
        #expect(viewModel.basketItems.first!.count == 1, "The item quantity should be 1.")
    }

    @Test func viewModelAddSameItemTwice() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstItem = viewModel.foodItems.first!
        viewModel.addToBasket(firstItem)
        viewModel.addToBasket(firstItem)
        
        #expect(viewModel.basketItems.count == 1, "Same item added twice should still be 1 entry")
        #expect(viewModel.totalAmount == firstItem.price * 2, "Total amount should equal the price of the added item multiplied by 2.")
        #expect(viewModel.basketItems.first!.count == 2, "The item quantity should be 2.")
    }
    
    @Test func viewModelRemoveItemFromBasket() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstItem = viewModel.foodItems.first!
        viewModel.addToBasket(firstItem)
        viewModel.addToBasket(firstItem)
        
        viewModel.removeFromBasket(firstItem, false)
        #expect(viewModel.basketItems[0].count == 1, "Removing 1 item should decrement quantity by 1.")
        
        viewModel.removeFromBasket(firstItem, false)
        #expect(viewModel.basketItems.isEmpty, "Removing the last of an item should remove it from the basket.")
    }
    
    @Test func viewModelRemoveAllItemsFromBasket() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstItem = viewModel.foodItems.first!
        viewModel.addToBasket(firstItem)
        viewModel.addToBasket(firstItem)
        viewModel.addToBasket(viewModel.foodItems[1])
        
        viewModel.clearBasket()
        
        #expect(viewModel.basketItems.isEmpty, "Clear basket should remove all items.")
    }
    
    @Test func viewModelTotalAmountCalculatedCorrectly() async throws {
        let viewModel = ContentView.ViewModel()
        await viewModel.loadData()
        
        let firstItem = viewModel.foodItems.first!
        let secondItem = viewModel.foodItems[1]
        viewModel.addToBasket(firstItem)
        viewModel.addToBasket(firstItem)
        viewModel.addToBasket(secondItem)
        
        let expectedTotal = (firstItem.price * 2) + secondItem.price
        #expect(viewModel.totalAmount == expectedTotal, "Total amount in the basket should be the sum of the prices of the items in the basket.")
        
        viewModel.removeFromBasket(firstItem, false)
        let newExpectedTotal = firstItem.price + secondItem.price
        #expect(viewModel.totalAmount == newExpectedTotal, "Total amount in the basket should update correctly when an item is removed.")
        
    }
    
}
