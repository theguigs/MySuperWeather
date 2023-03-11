//
//  Engine.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

public class Engine {
    public var weatherService: WeatherService

    private let networkClient: NetworkClient

    public init(
        configuration: EngineConfiguration
    ) {
        self.networkClient = NetworkClient(configuration: configuration)
        
        self.weatherService = WeatherService(networkClient: networkClient)
    }
}
