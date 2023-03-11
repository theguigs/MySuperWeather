//
//  City.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

// MARK: - City
public struct City: Codable {
    public let name: String?
    public let localNames: [String: String]?
    public let lat, lon: Double?
    public let country: String?
    public let state: String?
}
