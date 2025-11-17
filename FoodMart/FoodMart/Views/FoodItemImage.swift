//
//  FoodItemImage.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-17.
//

import SwiftUI

struct FoodItemImage: View {
    
    var imageURL: URL
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            default:
                Rectangle()
                    .fill(.gray.opacity(0.5))
                    .aspectRatio(1, contentMode: .fill)
            }
        }
    }
}

#Preview {
    FoodItemImage(imageURL: FoodItem.example.image_url)
}
