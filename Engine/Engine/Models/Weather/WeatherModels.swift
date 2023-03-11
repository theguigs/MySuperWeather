//
//  WeatherModels.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

// MARK: - Welcome
public struct Welcome: Codable {
    let lat, lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let current: Current?
    let minutely: [Minutely]?
    let hourly: [Current]?
    let daily: [Daily]?
    let alerts: [Alert]?
}

// MARK: - Alert
public struct Alert: Codable {
    let senderName, event: String?
    let start, end: Int?
    let description: String?
    let tags: [String]?
}

// MARK: - Current
public struct Current: Codable {
    let dt, sunrise, sunset: Int?
    let temp, feelsLike: Double?
    let pressure, humidity: Int?
    let dewPoint, uvi: Double?
    let clouds, visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]?
    let pop: Double?
}

// MARK: - Weather
public struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Daily
public struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int?
    let moonset: Int?
    let moonPhase: Double?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
    let dewPoint, windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]?
    let clouds: Int?
    let pop, rain, uvi: Double?
}

// MARK: - FeelsLike
public struct FeelsLike: Codable {
    let day, night, eve, morn: Double?
}

// MARK: - Temp
public struct Temp: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
}

// MARK: - Minutely
public struct Minutely: Codable {
    let dt, precipitation: Int?
}
