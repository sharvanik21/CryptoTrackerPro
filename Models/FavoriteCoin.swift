//
//  FavoriteService.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 31.05.26.
//

import Foundation
import SwiftData

@Model
final class FavoriteCoin {
    @Attribute(.unique) var id: String
    var symbol: String
    var name: String
    var imageURL: String
    var addedAt: Date
    var price: Double?
    init(id: String, symbol: String, name: String, imageURL: String, price: Double?) {
        self.id = id
        self.symbol = symbol
        self.price = price
        self.name = name
        self.imageURL = imageURL
        self.addedAt = Date()
    }
    
    convenience init(from coin: Coin) {
        self.init(
            id: coin.id,
            symbol: coin.symbol,
            name: coin.name,
            imageURL: coin.image,
            price: coin.currentPrice
        )
    }
}
