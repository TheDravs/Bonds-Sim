//
//  BondSettings.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 27/03/2025.
//

import Foundation
import SwiftUI

class BondSettings: ObservableObject {
    // Published properties
    @Published var faceValue: Double = 1000.0 {
        didSet {
            // Make sure face value doesn't go below valid minimum
            if faceValue < minFaceValue {
                faceValue = minFaceValue
            }
            // Make sure face value doesn't exceed maximum
            if faceValue > maxFaceValue {
                faceValue = maxFaceValue
            }
        }
    }
    
    @Published var couponRate: Double = 0.04
    @Published var maturity: Double = 5.0
    @Published var creditRating: String = "Investment Grade"
    @Published var requiredRate: Double = 0.05
    
    // Add validation constants
    let minFaceValue: Double = 1.0
    let maxFaceValue: Double = 1000000.0
    
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
    
    var creditRatingDynamic: String {
        
        var rating: String
        
        if requiredRate > 0.08 {
             rating = "High Yield"
        } else {
            rating = "Investment Grade"
        }
        
        return rating
    }
    
    
    // Helper validation methods
    func validateFaceValue(_ value: Double) -> (isValid: Bool, message: String?) {
        if value <= 0 {
            return (false, "Face value must be greater than zero")
        }
        
        if value > maxFaceValue {
            return (false, "Face value cannot exceed $\(maxFaceValue.formatted())")
        }
        
        return (true, nil)
    }
    
    // Helper method to format currency
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
