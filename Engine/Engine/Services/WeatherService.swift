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
    public var forecastWeatherByCity: [GeocodedCity: Forecast] = [:]
    public var dailyForecastWeatherByCity: [GeocodedCity: DailyForecast] = [:]

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
                        self.forecastWeatherByCity[city] = forecast
                        self.dailyForecastWeatherByCity[city] = self.computeDailyForecast(forecast: forecast)
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

    private func computeDailyForecast(forecast: Forecast) -> DailyForecast {
        let list = forecast.list ?? []
        
        let groups = Dictionary(grouping: list, by: { $0.dateWithoutTime })
            .filter({ $0.value.count > 6 || $0.key.isToday }) // Keep dey only if we have enough data
        
        let dayForecasts = groups
            .map({ $0.value.computeDayForecast(date: $0.key )})
            .sorted()
        
        return DailyForecast(dailies: dayForecasts)
    }
}
