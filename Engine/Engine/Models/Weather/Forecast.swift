//
//  Forecast.swift
//  Engine
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import Foundation

public struct Forecast: Codable {
    public let message: Int?
    public let cod: String?
    public let cnt: Int?
    public let list: [List]?
    public let city: City?
    
    public struct City: Codable {
        public let sunset: Int?
        public let country: String?
        public let id: Int?
        public let coord: Coord?
        public let population, timezone, sunrise: Int?
        public let name: String?
    }
    
    public struct List: Codable {
        public let clouds: Clouds?
        public let wind: Wind?
        public let dt: Int?
        public let rain: Rain?
        public let dtTxt: String?
        public let main: Main?
        public let weather: [Weather]?
        public let pop: Double?
        public let sys: Sys?
        public let visibility: Int?

        public struct Rain: Codable {
            public let forThreeHours: Double?
            
            enum CodingKeys: String, CodingKey {
                case forThreeHours = "3h"
            }
        }
    }
}
