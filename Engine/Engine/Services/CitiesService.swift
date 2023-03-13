//
//  CitiesService.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

public class CitiesService: AsyncCacheHandling {    
    static let citiesFilename = "CitiesService.cities"
    
    let networkClient: NetworkClient
    let fileDataStore: FileDataStore

    public var cities: [GeocodedCity] = [] {
        didSet {
            persistAsync(
                object: cities,
                filename: Self.citiesFilename,
                directory: fileDataStore.rootDirectory()
            )
        }
    }
    
    init(networkClient: NetworkClient, fileDataStore: FileDataStore) {
        self.networkClient = networkClient
        self.fileDataStore = fileDataStore
    }
    
    public func readCitiesFromCache(completion: @escaping (Bool) -> Void) {
        readFromCacheAsync(
            filename: Self.citiesFilename,
            directory: fileDataStore.rootDirectory()
        ) { [weak self] (cities: [GeocodedCity]?) in
            guard let self, let cities else {
                WLOG("[CitiesService] No cities cached data")
                completion(false)
                return
            }
            
            ILOG("[CitiesService] cities read from cache")
            self.cities = cities
            
            completion(true)
        }
    }
        
    /// Fetch cities from a given string query
    ///
    /// - Parameters:
    ///     - query: String query from TextField
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Producte tuple of 2 params ([GeocodedCity] & Error) both optionals
    public func fetchCities(for query: String, completion: @escaping ([GeocodedCity]?, Error?) -> Void) {
        guard !query.isEmpty else {
            completion([], nil)
            return
        }
        
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
    
    public func deleteCitiesCache() {
        fileDataStore.deleteFileIfExists(in: fileDataStore.rootDirectory(), filename: Self.citiesFilename)
    }
}
