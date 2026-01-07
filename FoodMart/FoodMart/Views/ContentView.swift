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
                FoodItemsView(foodItems: viewModel.filteredFoodItems, categories: viewModel.categories, basketItems: $viewModel.basketItems, addToBasket: viewModel.addToBasket)
                    .padding()
                    .navigationTitle("Food")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Filter") {
                                viewModel.showFilter = true
                            }
                        }
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Basket", systemImage: "basket") {
                                viewModel.showBasket = true
                            }
                            .badge(viewModel.basketItems.reduce(0) { $0 + $1.count})
                        }
                    }
                    .sheet(isPresented: $viewModel.showFilter) {
                        FilterView(categories: viewModel.categories, selectedCategories: $viewModel.selectedCategories, saveFilter: viewModel.saveFilter)
                            .padding()
                            .presentationDetents([.fraction(0.35)])
                    }
                    .sheet(isPresented: $viewModel.showBasket) {
                        BasketView(basketItems: $viewModel.basketItems, addToBasket: viewModel.addToBasket)
                    }
            }
        }
        .task(viewModel.loadData)
        
    }
    
    
}

#Preview {
    ContentView()
}
