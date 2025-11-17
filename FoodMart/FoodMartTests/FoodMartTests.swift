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

}
