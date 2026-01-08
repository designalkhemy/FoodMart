//
//  FilterView.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-16.
//

import SwiftUI

struct FilterView: View {
    
    let categories: [Category]
    @Binding var selectedCategories: Set<String>
    
    var saveFilter: () -> Void
    
    var body: some View {
        VStack {
            ForEach(categories.sorted(by: { $0.name < $1.name})) { category in
                Toggle(category.name, isOn: Binding(
                    get: { selectedCategories.contains(category.uuid) },
                    set: { isSelected in
                        if isSelected {
                            selectedCategories.insert(category.uuid)
                        } else {
                            selectedCategories.remove(category.uuid)
                        }
                        saveFilter()
                    }
                ))
            }
            
            Button("Clear Filter") {
                selectedCategories.removeAll()
            }
        }
    }
    
    
}

#Preview {
    FilterView(categories: [.exampleCategory], selectedCategories: .constant([])) {
        // do nothing
    }
}
