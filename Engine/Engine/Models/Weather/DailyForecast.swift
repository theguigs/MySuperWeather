//
//  DailyForecast.swift
//  Engine
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import Foundation

public struct DailyForecast: Codable {
    public let dailies: [DayForecast]
}

public struct DayForecast: Codable {
    public let date: Date
    
    public let main: Main
    public let wind: Wind
    
    public let weather: Weather?
}

extension DayForecast: Equatable, Comparable {
    static public func ==(lhs: DayForecast, rhs: DayForecast) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(lhs.date, inSameDayAs: rhs.date)
    }

    static public func <(lhs: DayForecast, rhs: DayForecast) -> Bool {
        return lhs.date < rhs.date
    }
}
