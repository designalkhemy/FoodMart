//
//  ContentView.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationStack {
            switch viewModel.loadState {
            case .loading:
                ProgressView("Loading...")
            case .failed:
                LoadFailedView(retry: viewModel.loadData)
            default:
                FoodItemsView(foodItems: viewModel.sortedFoodItems, categories: viewModel.categories, basketItems: $viewModel.basketItems, addToBasket: viewModel.addToBasket)
                    .padding()
                    .navigationTitle("Food")
                    .searchable(text: $viewModel.searchText)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Basket", systemImage: "basket") {
                                viewModel.showBasket = true
                            }
                            .badge(viewModel.basketItems.reduce(0) { $0 + $1.count})
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu("Sort") {
                                Picker("Sort", selection: $viewModel.sortBy) {
                                    Text("Name (A-Z")
                                        .tag(SortBy.name)
                                    
                                    Text("Price (low-high)")
                                        .tag(SortBy.price)
                                }
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Filter") {
                                viewModel.showFilter = true
                            }
                        }
                        
                    }
                    .sheet(isPresented: $viewModel.showFilter) {
                        FilterView(categories: viewModel.categories, selectedCategories: $viewModel.selectedCategories, saveFilter: viewModel.saveFilter, clearFilter: viewModel.clearFilter)
                            .padding()
                            .presentationDetents([.fraction(0.35)])
                    }
                    .sheet(isPresented: $viewModel.showBasket) {
                        BasketView(basketItems: $viewModel.basketItems, addToBasket: viewModel.addToBasket, removeFromBasket: viewModel.removeFromBasket, clearBasket: viewModel.clearBasket, totalAmount: viewModel.totalAmount)
                    }
            }
        }
        .task(viewModel.loadData)
        
    }
    
    
}

#Preview {
    ContentView()
}
