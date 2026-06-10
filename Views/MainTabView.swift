//
//  MainTabView.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 31.05.26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("All coins", systemImage: "bitcoinsign.circle.fill")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}
