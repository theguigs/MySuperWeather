//
//  CitiesService.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

public class CitiesService {
    let networkClient: NetworkClient
    
    public var cities: [GeocodedCity] = []
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
        
    public func fetchCities(for query: String, completion: @escaping ([GeocodedCity]?, Error?) -> Void) {
        let dict: [String: Any] = [
            "q": query,
            "limit": 5,
            "appid": K.OpenWeatherMap.ApiKey
        ]
        
        networkClient.call(
            endpoint: GeocodingEndpoints.geocoding,
            dict: dict,
            parameterEncoding: .URL
        ) { result in
            switch result {
                case .success((let data, _)):
                    do {
                        let cities = try JSONDecoder.snakeDecoder.decode([GeocodedCity].self, from: data)
                        completion(cities, nil)
                    } catch let error {
                        ELOG("[CitiesService] fetchCities error : \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    ELOG("[WeatherService] fetchCurrentWeather error : \(error)")
                    completion(nil, error)
            }
        }
        
    }
}
