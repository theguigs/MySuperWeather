//
//  WeatherModels.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

// MARK: - Clouds
public struct Clouds: Codable {
    public let all: Int?
}

// MARK: - Coord
public struct Coord: Codable {
    public let lon, lat: Double?
}

// MARK: - Main
public struct Main: Codable {
    public let temp: Double?
    public let tempMin: Double?
    public let tempMax: Double?
    public let feelsLike: Double?
    public let humidity: Int?
    public let pressure: Int?
    
    public let tempKf: Double?
    public let seaLevel: Int?
    public let grndLevel: Int?
}

// MARK: - Sys
public struct Sys: Codable {
    public let id: Int?
    public let country: String?
    public let sunset, type, sunrise: Int?
    public let pod: String?
}

// MARK: - Weather
public struct Weather: Codable {
    public let id: Int?
    public let main, icon, description: String?
}

// MARK: - Wind
public struct Wind: Codable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double? // Rafale
}

// MARK: - Rain
public struct Rain: Codable {
    public let forThreeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case forThreeHours = "3h"
    }
}

