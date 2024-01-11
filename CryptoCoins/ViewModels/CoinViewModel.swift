//
//  CoinViewModel.swift
//  CryptoCoins
//
//  Created by Benjamin. on 09/01/2024.
//

import Alamofire
import Foundation

enum CoinState {
    case initial
    case loading
    case error
}

class CoinViewModel: ObservableObject {
    
    @Published var coin = ""
    @Published var price = ""
    @Published var coins = [CoinsModel]()
    @Published var isLoading = false
    @Published var errMsg = ""
    
    let service = CoinService.shared
    
    init(){
        Task{
            //   fetchCoins("bitcoin")
            //   await alaFetch()
              await fetchMarket()
        }
        // fetchCoins()
    }
    
    func fetchCoins(_ coin:String) {
        service.fetchCoins(coin: coin) { data in
            DispatchQueue.main.async {
                self.price = data.price
                self.coin = data.coin
            }
        }
    }
    
    func fetchMarket() async {
            do{
              let coins =  try await service.getMarket(page: 1, limit: 20)
                self.coins = coins
            } catch {
                self.errMsg = error.localizedDescription
            }
        
        
        //Completion Handler
//        service.fetchCoinMarket(page: 1, limit: 10) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let coins):
//                    self?.coins = coins
//                case .failure(let error):
//                    self?.errMsg = error.description
//
//                }
//            }
//
//        }
    }
    
    
    //    func alaFetch() async {
    //        let res = await AF.request("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")
    //
    //        guard let data = res.data else {
    //            return
    //        }
    //        print(data)
    //
    //    }
}
