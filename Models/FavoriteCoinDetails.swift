//
//  FavoriteCoinDetails.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 09.06.26.
//

import Foundation


/// Combines a saved FavoriteCoin with its current market data from the API.
/// This pattern lets us merge persistent data (SwiftData) with fresh remote data.
struct FavoriteCoinDetails: Identifiable, Hashable {
    let favorite: FavoriteCoin
    let coin: Coin
    
    var id: String { favorite.id }
    
    static func == (lhs: FavoriteCoinDetails, rhs: FavoriteCoinDetails) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
