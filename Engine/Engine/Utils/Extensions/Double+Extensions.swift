//
//  Double+Extensions.swift
//  Engine
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import Foundation

extension Double {
    public func rounded(decimalCount: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double {
        let divisor = pow(10.0, Double(decimalCount))
        return (self * divisor).rounded(rule) / divisor
    }
}
