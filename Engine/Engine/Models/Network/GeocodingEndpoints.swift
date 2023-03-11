//
//  GeocodingEndpoints.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

enum GeocodingEndpoints: Endpoint {
    case geocoding
    
    var verb: HTTPVerb {
        switch self {
            case .geocoding:
                return .get
        }
    }
    
    var path: String {
        switch self {
            case .geocoding:
                return "/geo/1.0/direct"
        }
    }
}
