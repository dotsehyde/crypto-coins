//
//  CoinModel.swift
//  CryptoCoins
//
//  Created by Benjamin. on 10/01/2024.
//

import Foundation

struct Coin {
    var coin:String
    var price:String
}

// MARK: - CoinElement
struct CoinsModel: Codable, Identifiable, Hashable {
    var id, symbol, name: String
    var image: String
    var currentPrice: Double
    var marketCap, marketCapRank: Int
    var priceChangePercentage24H: Double
    var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case lastUpdated = "last_updated"
    }
}


// MARK: - CoinService
class CoinService {
    
    static let shared = CoinService()
    
    // MARK: - Fetch Market Coins
    func fetchCoinMarket(page:Int? ,limit:Int? ,completion: @escaping (Result<[CoinsModel], CoinError>)->()) {
        let limit = limit ?? 10
       let page = page ?? 1
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(limit)&page=\(page)&sparkline=false&locale=en") else{
            print("Could't parse URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            //Error
            if let error = error {
                completion(.failure(CoinError.unknownError(error: error)))
                return
            }
            //Response
            guard let res = response as? HTTPURLResponse else{
                completion(.failure(.requestError(desc: "Request failed")))
                return
            }
            guard res.statusCode == 200 else{
                completion(.failure(.invalidStatus(code: res.statusCode)))
                return
            }
            
            //Data
            guard let data = data else{
                print("Data is empty")
                return
            }
            do{
                let coins = try JSONDecoder().decode([CoinsModel].self, from: data)
                completion(.success(coins))
            }catch{
                completion(.failure(.jsonParseError))
            }
         
        }.resume()
        
        
    }
    
    func fetchCoins(coin:String, completion: @escaping (Coin) -> Void)  {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else{
                print("Response returned status code not 200")
                return
            }
            guard let data = data else {
                return
            }
            guard let data = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else { return }
            guard let value = data["bitcoin"] as? [String: Any] else {
                print("Couldn't parse data into value dict")
                return}
            guard let price = value["usd"] as? Double else{
                print("Couldn't parse values['usd'] into Double")
                return
            }
            
            completion(Coin(coin: coin.capitalized, price: "$\(price)"))
        }.resume()
        
    }
    
}

enum CoinError: Error {
    case invalidData
    case jsonParseError
    case requestError(desc: String)
    case invalidStatus(code:  Int)
    case unknownError(error: Error)
    
    var description:String{
        switch self {
        case.invalidData:
            return "Error fetching data"
        case .jsonParseError:
            return "Error parsing JSON"
        case let .requestError(desc): return "Request failed: \(desc)"
        case let .invalidStatus(code): return "Invalid status code: \(code)"
        case let .unknownError(error): return "An unknown error occurred\n\(error.localizedDescription)"
        }
    }
}
