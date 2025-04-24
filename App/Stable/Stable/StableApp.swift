//
//  StableApp.swift
//  Stable
//
//  Created by Kam Nagra on 24/04/2025.
//

import SwiftUI

// Starting fresh with a basic app structure
@main
struct StableApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

// Simple MainView that will work for sure
struct MainView: View {
    var body: some View {
        Text("Anchor App")
            .font(.largeTitle)
    }
}

// This placeholder structure is needed to satisfy the requirement
// that a module with @main cannot contain top-level code
struct StableAppBootstrap {}
