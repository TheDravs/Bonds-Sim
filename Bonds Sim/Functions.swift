//
//  Functions.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 24/03/2025.
//

import SwiftUI


func BondPrice(_ faceValue: Double, _ rate: Double, _ coupon: Double, _ years: Double) -> Double {
    let discountFactor = (1 - pow(1 + rate, -years)) / rate
    let presentValueCoupons = coupon * discountFactor
    let presentValueFaceValue = faceValue / pow(1 + rate, years)
    
    return presentValueCoupons + presentValueFaceValue
}
