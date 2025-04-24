//
//  ContentView.swift
//  Stable
//
//  Created by Kam Nagra on 24/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.stablePrimary
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                Text("Stable")
                    .font(.stableTitle())
                    .foregroundColor(.white)
                
                Text("whenever you're ready")
                    .font(.stableSubtitle())
                    .foregroundColor(.stableTextSecondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
