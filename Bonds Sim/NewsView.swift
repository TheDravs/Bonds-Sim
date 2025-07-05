//
//  NewsView.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 05/07/2025.
//

import SwiftUI

struct NewsView: View {
    
    @ObservedObject var newsViewModel: BondSettings
    @State private var directorsDealings: [DirectorsDealing] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading directors dealings...")
                        .padding()
                } else if let error = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if directorsDealings.isEmpty {
                    VStack {
                        Image(systemName: "doc.text")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No directors dealings data available")
                            .font(.headline)
                            .padding()
                    }
                } else {
                    List(directorsDealings, id: \.filename) { dealing in
                        DirectorsDealingRow(dealing: dealing)
                    }
                }
            }
            .navigationTitle("Directors Dealings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadData) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        isLoading = true
        errorMessage = nil
        
        // Get yesterday's date
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: yesterday)
        
        let urlString = "https://raw.githubusercontent.com/TheDravs/Directors-Dealings/main/data/Directors_Dealings_\(dateString).json"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([DirectorsDealing].self, from: data)
                    directorsDealings = decodedData
                } catch {
                    errorMessage = "Failed to parse data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct DirectorsDealingRow: View {
    let dealing: DirectorsDealing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dealing.emetteur)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(dealing.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text(dealing.nature)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
                Text(dealing.montant)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Price: \(dealing.prix)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Volume: \(dealing.volume)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("Transaction: \(dealing.transaction)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// Data model for directors dealings
struct DirectorsDealing: Codable {
    let filename: String
    let emetteur: String
    let transaction: String
    let date: String
    let nature: String
    let prix: String
    let volume: String
    let montant: String
}

// Preview
struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(newsViewModel: BondSettings())
    }
}
