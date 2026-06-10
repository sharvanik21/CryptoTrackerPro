# 📈 CryptoTracker Pro

A modern iOS app to track cryptocurrency prices in real-time. Built with SwiftUI and the latest Apple frameworks.

![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📱 About The App

CryptoTracker Pro is an iOS app that lets users:

- View live prices of the top 50 cryptocurrencies
- See detailed information about any coin
- View 7-day price history with interactive charts
- Save favorite coins for quick access
- Search and filter through coins
- Track price changes with mini sparkline charts

The app uses the free CoinGecko API for real cryptocurrency data.

---

## ✨ Features

### 🏠 Home Screen
- List of top 50 cryptocurrencies
- Real-time prices in USD
- 24-hour price change percentage
- Search bar to find coins quickly
- Pull down to refresh prices

### 📊 Detail Screen
- Large coin icon and name
- Current price with 24h change
- Beautiful 7-day price chart with gradient
- Statistics: Market Cap, Volume, 24h High/Low
- Tap the star icon to add to favorites
- Auto-refresh every 30 seconds

### ⭐ Favorites Screen
- All your saved favorite coins
- Live prices with mini sparkline charts
- 24h price change with up/down arrows
- Tap any coin to see details
- Swipe left to remove from favorites
- Beautiful empty state when no favorites
- Pull down to refresh

---

## 🛠 Technologies Used

| Technology | What It's Used For |
|------------|-------------------|
| **Swift 5.9** | Programming language |
| **SwiftUI** | Building the user interface |
| **Swift Concurrency** | Modern async/await code |
| **Swift Charts** | Drawing price charts |
| **SwiftData** | Saving favorites on device |
| **URLSession** | Making API calls |
| **MVVM** | Code architecture pattern |

---

## 🏗 Architecture

The app uses **MVVM (Model-View-ViewModel)** pattern for clean code:

- **Models** - Data structures (Coin, FavoriteCoin)
- **Views** - SwiftUI screens that users see
- **ViewModels** - Business logic and data formatting
- **Services** - Network calls and data fetching

This separation makes the code:
- Easy to read
- Easy to test
- Easy to maintain
- Easy to add new features

---

## 👨‍💻 Author

**Sharvani Karrepu**        

- LinkedIn: https://www.linkedin.com/in/sharvanikarrepu/
- GitHub: sharvanik21  
- Email: sharvanikarrepu@gmail.com
