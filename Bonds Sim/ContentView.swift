//
//  ContentView.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 24/03/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var referenceRate = 0.5
    @State private var creditSpread = 0.8

    @State private var creditRating = "Investment Grade"
    @State private var maturity = 1.0
    @State private var couponRate = 5.0
    @State private var faceValue = 1000.0
    
    @State private var bondPrice = 0.0
    
// MARK: Computed Properties
    private var rate: Double {
        (referenceRate + creditSpread) / 100
    }
    
    var creditSpreadRange: ClosedRange<Double> {
        creditRating == "Investment Grade" ? 0.0...1.0 : 1.0...5.0
    }
    
    var couponSpreadRange: ClosedRange<Double> {
        creditRating == "Investment Grade" ? 1.0...5.0 : 5.0...10.0
    }
    
    
    var coupon: Double {
        return faceValue * couponRate / 100
    }
    
    
// MARK: Formatter
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    
    
    // MARK: Start of the code
    var body: some View {
            NavigationStack {
                VStack {
                    List {
                        
                        
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
                                        
                                        TextField("", value: $faceValue, formatter: currencyFormatter)
                                            .keyboardType(.decimalPad)
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                            .accessibilityLabel("Face Value Input")
                                            .onChange(of: faceValue) { newValue in
                                                if newValue < 0 {
                                                    faceValue = 0
                                                }
                                            }
                                    }
                                    
                                    Picker("Coupon Rate", selection: $couponRate) {
                                        ForEach(Array(stride(from: couponSpreadRange.lowerBound,
                                                             through: couponSpreadRange.upperBound,
                                                             by: 0.1)), id: \.self) { value in
                                            Text(String(format: "%.2f", value))
                                                .tag(value) // Ensure tag matches value type
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
                                    
                                    
                                    
                                    Picker("Credit Rating", selection: $creditRating) {
                                        Text("Investment Grade").tag("Investment Grade")
                                        Text("HY").tag("HY")
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
                                    
                                    
                                    
                                    
                                    
                                    Picker("Reference Rate", selection: $referenceRate) {
                                        ForEach(Array(stride(from: 0.0, to: 1.1, by: 0.1)), id: \.self) {
                                            Text(String(format: "%.2f", $0))}
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
                                .padding(.vertical, 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                
                               
                                Text("Credit Spread")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $creditSpread, in: creditSpreadRange, step: 0.1) {
                                    Text("Credit Spread")
                                }
                                .accentColor(.blue)
                                .padding(.vertical, 1)
                                
                                
                                HStack {
                                    Spacer()
                                    Text(String(format: "%.1f", creditSpread))
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                    
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Maturity")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $maturity, in: 1...10, step: 1.0) {
                                    Text("Bond's Maturity")
                                }
                                .padding(.vertical, 5)
                                .accentColor(.blue)
                                .padding(.vertical, 1)
                                
                                HStack {
                                    Spacer()
                                    Text(String(format: "%.0f", maturity))
                                    Text("years")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                }
                            }
                        }
                        Text(String(format: "%.2f",bondPrice))
                        
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x:0,y:2)
                        

                    }
                  
                } // VStack
                    .listStyle(.insetGrouped)
                    
                
                
                
                
                
                
                
                
                
                
                
                
                
                    Spacer()
                    
                    Button(action: {
                        // Your action here
                        bondPrice = BondPrice(faceValue, rate, coupon, maturity)
                    }) {
                        Text("Calculate Bond Price")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .navigationTitle("Bonds Sim")
                    .navigationBarTitleDisplayMode(.large)
                }
                
            }
        } //end body
        


#Preview {
    ContentView()
}
