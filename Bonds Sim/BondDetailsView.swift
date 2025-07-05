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
                .padding(.bottom, 5)

            VStack(spacing: 10) {
                HStack {
                    Text("Face Value:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("$\(bondSettings.faceValue, specifier: "%.2f")")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Bond Price:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("$\(bondSettings.bondPriceDynamic, specifier: "%.2f")")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Coupon Rate:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(bondSettings.couponRate * 100, specifier: "%.2f")%")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Required Rate:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(bondSettings.requiredRate * 100, specifier: "%.2f")%")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Maturity:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(bondSettings.maturity, specifier: "%.0f") years")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Credit Rating:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(bondSettings.creditRatingDynamic)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Duration:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(String(format: "%.2f", duration))
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 3))

            VStack {
               

                ChartView(bondSettings: bondSettings)
                    .frame(height: 250)
                  
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
