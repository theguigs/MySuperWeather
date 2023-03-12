//
//  WeatherEndpoints.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

enum WeatherEndpoints: Endpoint {
    case currentWeather
    case hourlyWeather
    
    var verb: HTTPVerb {
        switch self {
            case .currentWeather, .hourlyWeather:
                return .get
        }
    }
    
    var path: String {
        switch self {
            case .currentWeather:
                return "/data/2.5/weather"
            case .hourlyWeather:
                return "/data/2.5/forecast"
        }
    }
}
