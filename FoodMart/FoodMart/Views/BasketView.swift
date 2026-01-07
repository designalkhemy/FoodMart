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
    
    var totalAmount: Decimal {
        switch basketItems.count {
        case 0:
            return 0
        default:
            return basketItems.reduce(0) { $0 + $1.foodItem.price * Decimal($1.count) }
        }
    }
    
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
    
    private func removeFromBasket(_ foodItem: FoodItem, _ removeAll: Bool) {
        if let index = basketItems.firstIndex(where: { $0.foodItem.uuid ==  foodItem.uuid}) {
            
            basketItems[index].count -= 1
            
            if basketItems[index].count == 0 || removeAll {
                basketItems.remove(at: index)
            }
        }
    }
    
    private func clearBasket() {
        basketItems.removeAll()
    }
}

#Preview {
    BasketView(
        basketItems: .constant([BasketItem(foodItem: .example, count: 1)])) { _ in
        // do nothing
    }
}
