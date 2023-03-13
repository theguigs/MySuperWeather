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
    
    /// Fetch the current weather for a given city
    ///
    /// - Parameters:
    ///     - city: City used to get lat & long param
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Producte tuple of 2 params (Current & APIError) both optionals
    public func fetchCurrentWeather(city: GeocodedCity, completion: @escaping (Current?, APIError?) -> Void) {
        guard let lat = city.lat, let lon = city.lon else {
            completion(nil, APIError.missingParam)
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
                        let apiError = APIError.unexpectedAPIResponse
                        completion(nil, apiError)
                    }
                case .failure(let error):
                    ELOG("[WeatherService] fetchCurrentWeather error : \(error)")
                    let apiError = APIError.requestFailure
                    completion(nil, apiError)
            }
        }
    }
    
    /// Fetch hourly weather forecast for a given city
    ///
    /// - Parameters:
    ///     - city: City used to get lat & long param
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Producte tuple of 2 params (Forecast & Error) both optionals
    public func fetchHourlyWeather(city: GeocodedCity, completion: @escaping (Forecast?, APIError?) -> Void) {
        guard let lat = city.lat, let lon = city.lon else {
            completion(nil, APIError.missingParam)
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
                        let apiError = APIError.unexpectedAPIResponse
                        completion(nil, apiError)
                    }
                case .failure(let error):
                    ELOG("[WeatherService] fetchCurrentWeather error : \(error)")
                    let apiError = APIError.requestFailure
                    completion(nil, apiError)
            }
        }
    }
    
    /// Compute new model from fetchHourlyWeather response
    ///
    /// - Parameters:
    ///     - forecast: fetchHourlyWeather response
    ///
    /// - Returns:
    ///     - DailyForecast: This new models provide data aggregated by days

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
