//
//  ContentView.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 24/03/2025.
//

import SwiftUI

struct ContentView: View {
    // Utiliser l'objet observé passé par TabViewContainer
    @ObservedObject var bondSettings: BondSettings
    
    @FocusState private var isFaceValueFocused: Bool
    
// MARK: Formatter
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.maximum = 1000000  // Set a high maximum
        return formatter
    }()
    
    // MARK: Start of the code
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    
                    
                     Section {
                         VStack(alignment: .leading) {
                             Text("$" + String(format: "%.2f", bondSettings.bondPriceDynamic))
                                 .fontWeight(.bold)
                                 .foregroundStyle(.white)
                                 .padding()
                                 .frame(maxWidth: .infinity)
                                 .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .trailing))
                                 .clipShape(RoundedRectangle(cornerRadius: 12))
                                 .shadow(color: Color.blue.opacity(0.3), radius: 5, x:0,y:2)
                         }
                     }
                    
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Credit Parameters")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.bottom, 5)
                            
                            VStack {
                                HStack {
                                    Text("Face Value: $")
                                        .foregroundColor(.primary)
                                    
                                    TextField("", value: $bondSettings.faceValue, formatter: currencyFormatter)
                                        .keyboardType(.decimalPad)
                                        .focused($isFaceValueFocused)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Done") {
                                                    isFaceValueFocused = false  // Dismiss keyboard
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        .accessibilityLabel("Face Value Input")
                                        .onChange(of: bondSettings.faceValue) { newValue in
                                            if newValue < 0 {
                                                bondSettings.faceValue = 0
                                            }
                                        }
                                }
                                
                                Picker("Coupon Rate", selection: $bondSettings.couponRate) {
                                    ForEach(Array(stride(from: bondSettings.couponSpreadRange.lowerBound,
                                                         through: bondSettings.couponSpreadRange.upperBound,
                                                         by: 0.01)), id: \.self) { value in
                                        Text(String(format: "%.2f%%", value * 100)) // Multiply by 100 and append "%" symbol
                                            .tag(value)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                
                                Picker("Required Rate", selection: $bondSettings.requiredRate) {
                                    ForEach(Array(stride(from: bondSettings.creditSpreadRange.lowerBound,
                                                         through: bondSettings.creditSpreadRange.upperBound,
                                                         by: 0.01)), id: \.self) { value in
                                        Text(String(format: "%.2f%%", value * 100)) // Multiply by 100 and append "%" symbol
                                            .tag(value)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            .padding(.vertical, 15)
                        }
                        
                        Section {
                            VStack(alignment: .leading) {
                                Text("Maturity")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $bondSettings.maturity, in: 1...10, step: 1.0) {
                                    Text("Bond's Maturity")
                                }
                                .padding(.vertical, 5)
                                .accentColor(.blue)
                                .padding(.vertical, 5)
                                
                                HStack {
                                    Spacer()
                                    Text(String(format: "%.0f", bondSettings.maturity))
                                    Text("years")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                   
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    ContentView(bondSettings: BondSettings())
}
