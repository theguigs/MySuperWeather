//
//  Current.swift
//  Engine
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import Foundation

// MARK: - Current
public struct Current: Codable {
    public let id: Int
    public let base: String?
    public let dt: Int?
    public let main: Main?
    public let coord: Coord?
    public let wind: Wind?
    public let sys: Sys?
    public let weather: [Weather]?
    public let visibility: Int?
    public let clouds: Clouds?
    public let timezone, cod: Int?
    public let name: String?
}
