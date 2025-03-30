//
//  BondViewModel.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 30/03/2025.
//

import Foundation

class BondViewModel: ObservableObject {
    @Published var usTreasuryPrice: String?
    @Published var frenchOATPrice: String?

    private let apiKey = "67e940cb945f71.50773478"  // Store securely in production!
    private let baseURL = "https://eodhistoricaldata.com/api/"

    func fetchBondPrices() {
        let url = URL(string: "https://eodhistoricaldata.com/api/eod/US10Y.GBOND?api_token=\(apiKey)&fmt=json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching bond prices: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(rawResponse)") // Debugging step
            }

            do {
                let decodedResponse = try JSONDecoder().decode([BondIndicator].self, from: data)
                // Sort the response by date in descending order to get the latest price
                if let latestPrice = decodedResponse.sorted(by: { $0.date > $1.date }).first?.close {
                    DispatchQueue.main.async {
                        self.usTreasuryPrice = "\(latestPrice)"
                    }
                } else {
                    print("No bond price found in response")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }

    func fetchFrenchOATPrices() {
        let url = URL(string: "https://eodhistoricaldata.com/api/eod/FR10Y.GBOND?api_token=\(apiKey)&fmt=json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching bond prices: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(rawResponse)") // Debugging step
            }

            do {
                let decodedResponse = try JSONDecoder().decode([BondIndicator].self, from: data)
                // Sort the response by date in descending order to get the latest price
                if let latestPrice = decodedResponse.sorted(by: { $0.date > $1.date }).first?.close {
                    DispatchQueue.main.async {
                        self.frenchOATPrice = "\(latestPrice)"
                    }
                } else {
                    print("No bond price found in response")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}

// Struct to Decode JSON Response
struct BondIndicator: Codable {
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let adjusted_close: Double
    let volume: Int
}

struct BondPriceResponse: Codable {
    let data: [BondIndicator]
}
