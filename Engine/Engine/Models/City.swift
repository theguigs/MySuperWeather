//
//  City.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation
import CoreLocation

// MARK: - City
public struct City: Codable {
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
