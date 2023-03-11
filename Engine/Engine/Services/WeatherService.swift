//
//  WeatherService.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

public class WeatherService {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
        
    public func fetchCurrentWeather(completion: @escaping (Current?, Error?) -> Void) {
        let dict: [String: Any] = [
            "lat": 48.856613,
            "lon": 2.352222,
            "units": "metric",
            "lang": "fr",
            "appid": K.OpenWeatherMap.ApiKey
        ]
        
        networkClient.call(
            endpoint: WeatherEndpoints.currentWeather,
            dict: dict,
            parameterEncoding: .URL
        ) { result in
            switch result {
                case .success((let data, _)):
                    do {
                        let current = try JSONDecoder.snakeDecoder.decode(Current.self, from: data)
                        completion(current, nil)
                    } catch let error {
                        ELOG("[WeatherService] fetchCurrentWeather error : \(error)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    ELOG("[WeatherService] fetchCurrentWeather error : \(error)")
                    completion(nil, error)
            }
        }
        
    }
}