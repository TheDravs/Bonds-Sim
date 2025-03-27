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
                Text("Coupon Rate:")
                Spacer()
                Text("\(bondSettings.couponRate * 100, specifier: "%.2f")%")
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
    let yields: [Double] = Array(stride(from: -2.0, through: 2.0, by: 0.1)) // Yield changes (e.g., -2% to +2%)
    
    var body: some View {
        VStack {
            Text("")
                .font(.headline)
                .padding(.top)
            
            Chart {
                // Convexity Curve
                ForEach(yields, id: \.self) { y in
                    LineMark(
                        x: .value("Yield Change", y),
                        y: .value("Price", bondPrice(for: y))
                    )
                    .foregroundStyle(.blue)
                }
                
                // Duration Tangent Line (approximate linear change)
                LineMark(
                    x: .value("Yield Change", -1.0),
                    y: .value("Price", bondPrice(for: -1.0))
                )
                .foregroundStyle(.red)
                .interpolationMethod(.linear)
                
                LineMark(
                    x: .value("", 1.0),
                    y: .value("", bondPrice(for: 1.0))
                )
                .foregroundStyle(.red)
                .interpolationMethod(.linear)
            }
            .frame(height: 250)
            .padding()
            .chartXAxis {
                AxisMarks(position: .bottom, values: .automatic) {
                    AxisValueLabel(String(format: "%.1f", $0.as(Double.self) ?? 0.0))
                    
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
    
    /// Function to simulate bond price based on yield changes (convexity effect)
    func bondPrice(for yieldChange: Double) -> Double {
        // Vous pourriez utiliser les valeurs réelles du bondSettings ici pour des calculs plus précis
        let initialPrice = bondSettings.faceValue // Utilisez la valeur faciale comme prix initial
        let duration = 6.5         // Vous pourriez calculer cela dynamiquement
        let convexity = 85.2       // Vous pourriez calculer cela dynamiquement
        
        let priceChange = (-duration * yieldChange) + (0.5 * convexity * yieldChange * yieldChange)
        return initialPrice + priceChange
    }
}

#Preview {
    BondDetailsView(bondSettings: BondSettings())
}
