//
//  WeatherService.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

public class WeatherService {
    let networkClient: NetworkClient
    
    public var currentWeatherByCity: [GeocodedCity: Current] = [:]
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
        
    public func fetchCurrentWeather(city: GeocodedCity, completion: @escaping (Current?, Error?) -> Void) {
        guard let lat = city.lat, let lon = city.lon else {
            completion(nil, nil)
            return
        }

        let dict: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "units": "metric",
            "lang": "fr",
            "appid": K.OpenWeatherMap.ApiKey
        ]
        
        networkClient.call(
            endpoint: WeatherEndpoints.currentWeather,
            dict: dict,
            parameterEncoding: .URL
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success((let data, _)):
                    do {
                        let current = try JSONDecoder.snakeDecoder.decode(Current.self, from: data)
                        self.currentWeatherByCity[city] = current
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
    
    public func fetchHourlyWeather(city: GeocodedCity, completion: @escaping (Forecast?, Error?) -> Void) {
        guard let lat = city.lat, let lon = city.lon else {
            completion(nil, nil)
            return
        }
        
        let dict: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "units": "metric",
            "lang": "fr",
            "appid": K.OpenWeatherMap.ApiKey
        ]
        
        networkClient.call(
            endpoint: WeatherEndpoints.hourlyWeather,
            dict: dict,
            parameterEncoding: .URL
        ) { result in
            switch result {
                case .success((let data, _)):
                    do {
                        let forecast = try JSONDecoder.snakeDecoder.decode(Forecast.self, from: data)
                        completion(forecast, nil)
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
