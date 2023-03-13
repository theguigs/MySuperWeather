//
//  TimeInterval+Extensions.swift
//  Engine
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import Foundation

extension TimeInterval {
    // MARK: - Computed Type Properties
    internal static var secondsPerMonthes: Double { return secondsPerDay * 30 }
    internal static var secondsPerDay: Double { return secondsPerHour * 24 }
    internal static var secondsPerHour: Double { return secondsPerMinute * 60 }
    internal static var secondsPerMinute: Double { return 60 }

    // MARK: - Type Methods
    /// - Returns: The time in monthes using the `TimeInterval` type.
    /// Be careful with this method, It is approximative.
    public static func monthes(_ value: Double) -> TimeInterval {
        return value * secondsPerMonthes
    }

    /// - Returns: The time in days using the `TimeInterval` type.
    public static func days(_ value: Double) -> TimeInterval {
        return value * secondsPerDay
    }

    /// - Returns: The time in hours using the `TimeInterval` type.
    public static func hours(_ value: Double) -> TimeInterval {
        return value * secondsPerHour
    }

    /// - Returns: The time in minutes using the `TimeInterval` type.
    public static func minutes(_ value: Double) -> TimeInterval {
        return value * secondsPerMinute
    }
}
