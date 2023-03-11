//
//  WeatherModels.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

// MARK: - Current
public struct Current: Codable {
    let id: Int
    let base: String?
    let dt: Int?
    let main: Main?
    let coord: Coord?
    let wind: Wind?
    let sys: Sys?
    let weather: [Weather]?
    let visibility: Int?
    let clouds: Clouds?
    let timezone, cod: Int?
    let name: String?
}

// MARK: - Clouds
public struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
public struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
public struct Main: Codable {
    let temp: Double?
    let tempMin: Double?
    let tempMax: Double?
    let feelsLike: Double?
    let humidity: Int?
    let pressure: Int?
}

// MARK: - Sys
public struct Sys: Codable {
    let id: Int
    let country: String?
    let sunset, type, sunrise: Int?
}

// MARK: - Weather
public struct Weather: Codable {
    let id: Int
    let main, icon, description: String?
}

// MARK: - Wind
public struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
