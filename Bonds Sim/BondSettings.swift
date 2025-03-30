//
//  BondSettings.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 27/03/2025.
//

import Foundation

class BondSettings: ObservableObject {
    @Published var faceValue: Double = 1000.0
    @Published var couponRate: Double = 0.04
    @Published var maturity: Double = 5.0
    @Published var creditRating: String = "Investment Grade"
    @Published var requiredRate: Double = 0.05
    
    // Computed properties
    var coupon: Double {
        return faceValue * couponRate
    }
    
    var bondPriceDynamic: Double {
        let discountFactor = (1 - pow(1 + requiredRate, -maturity)) / requiredRate
        let presentValueCoupons = coupon * discountFactor
        let presentValueFaceValue = faceValue / pow(1 + requiredRate, maturity)
        
        return presentValueCoupons + presentValueFaceValue
    }
    
    var creditSpreadRange: ClosedRange<Double> {
       0.01...0.1
    }
    
    var couponSpreadRange: ClosedRange<Double> {
     0.01...0.1
    }
}
