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
                FoodItemsView(foodItems: viewModel.filteredFoodItems, categories: viewModel.categories)
                    .padding()
                    .navigationTitle("Food")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Filter") {
                                viewModel.showFilter = true
                            }
                        }
                    }
                    .sheet(isPresented: $viewModel.showFilter) {
                        FilterView(categories: viewModel.categories, selectedCategories: $viewModel.selectedCategories)
                            .padding()
                            .presentationDetents([.fraction(0.35)])
                    }
            }
        }
        .task(viewModel.loadData)
        
    }
    
    
}

#Preview {
    ContentView()
}
