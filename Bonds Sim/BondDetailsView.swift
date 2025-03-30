//
//  BondDetailsView.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 27/03/2025.
//

import SwiftUI
import Charts

struct BondDetailsView: View {
    @ObservedObject var bondSettings: BondSettings
    
    var duration: Double {
        var numerator = 0.0
        var denominator = 0.0
        
        let coupon = bondSettings.coupon
        
        for t in 1...Int(bondSettings.maturity) {
            let discountFactor = pow(1 + bondSettings.requiredRate, Double(t))
            let presentValueCoupon = coupon / discountFactor
            numerator += Double(t) * presentValueCoupon
            denominator += presentValueCoupon
        }
        
        let discountFactorMaturity = pow(1 + bondSettings.requiredRate, bondSettings.maturity)
        let presentValueFaceValue = bondSettings.faceValue / discountFactorMaturity
        
        numerator += bondSettings.maturity * presentValueFaceValue
        denominator += presentValueFaceValue
        
        return numerator / denominator
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Bond Characteristics")
                .font(.title)
                .fontWeight(.bold)

            HStack {
                Text("Face Value:")
                Spacer()
                Text("$\(bondSettings.faceValue, specifier: "%.2f")")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Bond Price:")
                Spacer()
                Text("$\(bondSettings.bondPriceDynamic, specifier: "%.2f")")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Coupon Rate:")
                Spacer()
                Text("\(bondSettings.couponRate * 100, specifier: "%.2f")%")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Required Rate:")
                Spacer()
                Text("\(bondSettings.requiredRate * 100, specifier: "%.2f")%")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Maturity:")
                Spacer()
                Text("\(bondSettings.maturity, specifier: "%.0f") years")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Credit Rating:")
                Spacer()
                Text(bondSettings.creditRating)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Duration:")
                Spacer()
                Text(String(format: "%.2f", duration))
                    .fontWeight(.semibold)
            }

            Spacer()
            
            VStack {
                Text("Convexity & Duration")
                    .font(.headline)
                    .padding(.top)

                ChartView(bondSettings: bondSettings)
                    .frame(height: 200)
                    .padding()
            }
        }
        .padding()
    }
}

struct ChartView: View {
    @ObservedObject var bondSettings: BondSettings
    let yields: [Double] = Array(stride(from: 0.01, through: 0.1, by: 0.005)) // Interest rates from 1% to 10%
    
    var body: some View {
        VStack {
            Text("Bond Price Sensitivity to Interest Rate")
                .font(.headline)
                .padding(.top)
            
            Chart {
                // Plot bond price at different yields
                ForEach(yields, id: \.self) { y in
                    LineMark(
                        x: .value("Interest Rate", y * 100),  // Convert to percentage for readability
                        y: .value("Price", bondPrice(for: y))
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 250)
            .padding()
            .chartXAxis {
                AxisMarks(values: .stride(by: 2)) { value in  // Ensure the value is properly extracted
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.1f%%", doubleValue))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
    
    /// Function to calculate bond price dynamically based on different interest rates
    func bondPrice(for newRate: Double) -> Double {
        let coupon = bondSettings.coupon
        let faceValue = bondSettings.faceValue
        let maturity = Int(bondSettings.maturity)
        
        var price = 0.0
        
        // Discounted coupon payments
        for t in 1...maturity {
            price += coupon / pow(1.0 + newRate, Double(t))
        }
        
        // Discounted face value
        price += faceValue / pow(1.0 + newRate, Double(maturity))
        
        return price
    }
}


#Preview {
    BondDetailsView(bondSettings: BondSettings())
}
