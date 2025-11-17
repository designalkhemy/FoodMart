//
//  LoadFailedView.swift
//  FoodMart
//
//  Created by Jennifer on 2025-11-17.
//

import SwiftUI

struct LoadFailedView: View {
    
    var retry: () async -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Oops...")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("Something went wrong.")
            
            Spacer()
            
            Button("Retry") {
                Task {
                    await retry()
                }
            }
        }
    }
}

#Preview {
    LoadFailedView() {
        
    }
}
