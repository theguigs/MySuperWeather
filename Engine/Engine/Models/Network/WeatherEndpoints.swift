//
//  WeatherEndpoints.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

enum WeatherEndpoints: Endpoint {
    case onecall
    case endpoint2
    
    var verb: HTTPVerb {
        switch self {
            case .onecall:
                return .get
            case .endpoint2:
                return .post
        }
    }
    
    var path: String {
        switch self {
            case .onecall:
                return "/onecall"
            case .endpoint2:
                return "/api/..."
        }
    }
}
