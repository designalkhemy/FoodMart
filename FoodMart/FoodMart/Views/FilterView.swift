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
    
    var body: some View {
        VStack {
            ForEach(categories) { category in
                Toggle(category.name, isOn: Binding(
                    get: { selectedCategories.contains(category.uuid) },
                    set: { isSelected in
                        if isSelected {
                            selectedCategories.insert(category.uuid)
                        } else {
                            selectedCategories.remove(category.uuid)
                        }
                    }
                ))
            }
        }
    }
}

#Preview {
    FilterView(categories: [.exampleCategory], selectedCategories: .constant([]))
}
