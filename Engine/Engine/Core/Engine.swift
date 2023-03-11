//
//  Engine.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

public class Engine {
    private let networkClient: NetworkClient

    public var weatherService: WeatherService
    public var citiesService: CitiesService

    public init(
        configuration: EngineConfiguration
    ) {
        self.networkClient = NetworkClient(configuration: configuration)
        
        self.weatherService = WeatherService(networkClient: networkClient)
        self.citiesService = CitiesService(networkClient: networkClient)
    }
}
