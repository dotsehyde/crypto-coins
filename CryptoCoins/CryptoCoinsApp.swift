//
//  CryptoCoinsApp.swift
//  CryptoCoins
//
//  Created by Benjamin. on 09/01/2024.
//

import SwiftUI

@main
struct CryptoCoinsApp: App {
    @StateObject var coinViewModel:CoinViewModel = CoinViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(coinViewModel)
        }
    }
}
