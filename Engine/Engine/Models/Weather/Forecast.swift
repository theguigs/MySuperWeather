//
//  Forecast.swift
//  Engine
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import Foundation

public struct Forecast: Codable {
    public let message: Int?
    public let cod: String?
    public let cnt: Int?
    public let list: [List]?
    public let city: City?
    
    public struct City: Codable {
        public let sunset: Int?
        public let country: String?
        public let id: Int?
        public let coord: Coord?
        public let population, timezone, sunrise: Int?
        public let name: String?
    }
    
    public struct List: Codable {
        public let clouds: Clouds?
        public let wind: Wind?
        public let dt: Int?
        public let rain: Rain?
        public let dtTxt: String?
        public let main: Main?
        public let weather: [Weather]?
        public let pop: Double?
        public let sys: Sys?
        public let visibility: Int?
        
        public var date: Date {
            guard let dt else { return Date() }
            return Date(timeIntervalSince1970: TimeInterval(dt))
        }
        
        public var dateWithoutTime: Date {
            guard let dt else { return Date() }
            let date = Date(timeIntervalSince1970: TimeInterval(dt))
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let dateString = formatter.string(from: date)

            return formatter.date(from: dateString) ?? Date()
        }
    }
}

extension Array where Element == Forecast.List {
    func computeDayForecast(date: Date) -> DayForecast {
        let main = Main(
            temp: nil,
            tempMin: self.compactMap({ $0.main?.tempMin }).min(),
            tempMax: self.compactMap({ $0.main?.tempMax }).max(),
            feelsLike: nil,
            humidity: self.compactMap({ $0.main?.humidity }).average,
            pressure: nil,
            tempKf: nil,
            seaLevel: nil,
            grndLevel: nil
        )
        
        let wind = Wind(
            speed: self.compactMap({ $0.wind?.speed }).average,
            deg: self.compactMap({ $0.wind?.deg }).average,
            gust: self.compactMap({ $0.wind?.gust }).average
        )
        
        let clouds = Clouds(
            all: self.compactMap({ $0.clouds?.all }).average
        )
        
        let rain = Rain(
            forThreeHours: self.compactMap({ $0.rain?.forThreeHours }).sum
        )
        
        var weather: Weather?
        if self.count >= 4 {
            weather = self[3].weather?.first
        } else {
            weather = self.first?.weather?.first
        }
        
        return DayForecast(
            date: date,
            main: main,
            wind: wind,
            clouds: clouds,
            rain: rain,
            weather: weather
        )
    }
}
