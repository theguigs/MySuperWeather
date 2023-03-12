//
//  GeocodedCity.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation
import CoreLocation

// MARK: - GeocodedCity
public struct GeocodedCity: Codable {
    public var id: UUID?
    
    public let name: String?
    public let localNames: [String: String]?
    public let lat, lon: Double?
    public let country: String?
    public let state: String?
    
    public var location: CLLocation? {
        guard let lat, let lon else { return nil }
        return CLLocation(latitude: lat, longitude: lon)
    }
}

extension GeocodedCity: Equatable {
    static public func ==(lhs: GeocodedCity, rhs: GeocodedCity) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GeocodedCity: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
