//
//  WeatherEndpoints.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

enum WeatherEndpoints: Endpoint {
    case onecall
    case currentWeather
    
    var verb: HTTPVerb {
        switch self {
            case .onecall, .currentWeather:
                return .get
        }
    }
    
    var path: String {
        switch self {
            case .onecall:
                return "/data/3.0/onecall"
            case .currentWeather:
                return "/data/2.5/weather"
        }
    }
}
