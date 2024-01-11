//
//  HomeView.swift
//  CryptoCoins
//
//  Created by Benjamin. on 09/01/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    var body: some View {
        GeometryReader { geo in
            NavigationStack{
                List {
                    ForEach(coinViewModel.coins, id: \.id) { data in
                        NavigationLink(destination: Details(coin: data)) {
                            HStack(spacing: 10){
                                Text("\(data.marketCapRank)")
                                    .foregroundStyle(.secondary)
                                AsyncImage(url: URL(string: data.image)) { img in
                                    img.resizable()
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .fill(.gray)
                                }
                                .frame(width: 40, height: 40)
                                VStack(alignment: .leading, spacing:4){
                                    Text(data.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(data.symbol.uppercased())
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            

                            }.padding(.vertical,10)
                          
                        }
                       
                    }
                    
                }
                .navigationTitle("Crypto")
                .overlay {
                    if(!coinViewModel.errMsg.isEmpty){
                        Text(coinViewModel.errMsg)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
        }
        .task {
            coinViewModel.fetchMarket()
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CoinViewModel())
    }
}


struct Details: View {
    var coin:CoinsModel
    var body: some View {
        Text(coin.name )
    }
}
