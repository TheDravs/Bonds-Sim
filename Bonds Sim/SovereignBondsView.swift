//
//  SovereignBondsView.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 30/03/2025.
//

import SwiftUI

struct SovereignBondsView: View {
    @StateObject private var viewModel = BondViewModel()

    var body: some View {
        NavigationView {
            List {
                BondRowView(name: "10Y U.S. Treasury Note", price: viewModel.usTreasuryPrice)
                BondRowView(name: "10Y French OAT", price: viewModel.frenchOATPrice)
            }
            .navigationTitle("Sovereign Bonds")
            .onAppear {
                viewModel.fetchBondPrices()
                viewModel.fetchFrenchOATPrices()
            }
        }
    }
}

struct BondRowView: View {
    let name: String
    let price: String?

    var body: some View {
        HStack {
            Text(name)
            Spacer()
            if let price = price {
                Text(price)
                    .fontWeight(.bold)
            } else {
                ProgressView()
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    SovereignBondsView()
}
