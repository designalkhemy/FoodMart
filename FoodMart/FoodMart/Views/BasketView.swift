//
//  BasketView.swift
//  FoodMart
//
//  Created by Jennifer on 2026-01-07.
//

import SwiftUI

struct BasketView: View {
    
    @Binding var basketItems: [BasketItem]
    
    var addToBasket: (FoodItem) -> Void
    var removeFromBasket: (FoodItem, Bool) -> Void
    var clearBasket: () -> Void
    
    var totalAmount: Decimal
    
    var body: some View {
        switch basketItems.count {
        case 0:
            ContentUnavailableView("Your basket is empty", systemImage: "basket")
        default:
            VStack {
                Text("My Basket")
                    .font(.title)
                    .padding(.bottom, 30)
                
                Divider()
                
                ScrollView {
                    ForEach(basketItems) { item in
                        HStack {
                            Text(item.foodItem.name)
                                .font(.headline)
                                
                            Spacer()
                            
                            Text("$\(item.foodItem.price.formatted(.number))")
                                .padding(.horizontal, 10)
                            
                            HStack {
                                Button("Remove", systemImage: "minus.circle") {
                                    removeFromBasket(item.foodItem, false)
                                }
                                
                                Text("\(item.count)")
                                
                                Button("Add", systemImage: "plus.circle") {
                                    addToBasket(item.foodItem)
                                }
                            }
                            .labelStyle(.iconOnly)
                            
                            
                            Button("Remove from basket", systemImage: "trash") {
                                removeFromBasket(item.foodItem, true)
                            }
                            .accentColor(Color(.red))
                            .labelStyle(.iconOnly)
                            .padding(.leading, 10)
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Total")
                        .font(.title2.bold())
                        
                    Spacer()
                    
                    Text("$\(totalAmount.formatted(.number))")
                        .font(.title3.bold())
                }
                
                Divider()
                
                Button("Clear Basket") {
                    clearBasket()
                }
                .padding(.top, 30)
            }
            .padding()
        }
        
    }
    
}
