//
//  CryptoCurrencyTrackerApp.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 26.05.26.
//

import SwiftUI
import SwiftData
@main
struct CryptoCurrencyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: FavoriteCoin.self)
    }
}
