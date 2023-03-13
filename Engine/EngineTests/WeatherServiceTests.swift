//
//  WeatherServiceTests.swift
//  EngineTests
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import XCTest
import Engine

final class WeatherServiceTests: XCTestCase {

    var engine: Engine?
    var city: GeocodedCity?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let baseURL = URL(string: "https://api.openweathermap.org") else {
            XCTFail("Base URL is not a valid URL")
            return
        }

        let network = EngineConfiguration.Network(baseUrl: baseURL)
        let configuration = EngineConfiguration(network: network)
        
        self.engine = Engine(configuration: configuration)
        
        fetchOneCity()
        
    }
    
    private func fetchOneCity() {
        let didFetchCitiesExpectation = self.expectation(description: "Did fetch cities")
        engine?.citiesService.fetchCities(for: "Paris", completion: { cities, error in
            self.city = cities?.first
            didFetchCitiesExpectation.fulfill()
        })
        
        wait(for: [didFetchCitiesExpectation], timeout: 1)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingCurrentWeather() throws {
        guard let city else {
            XCTFail("Need a city")
            return
        }
        
        let didFetchCurrentWeatherExpectation = self.expectation(description: "Did fetch current weather")

        engine?.weatherService.fetchCurrentWeather(city: city, completion: { current, error in
            XCTAssertNil(error)
            XCTAssertNotNil(current)

            XCTAssertNotNil(current?.dt)
            XCTAssertNotNil(current?.main)
            
            didFetchCurrentWeatherExpectation.fulfill()
        })
        
        wait(for: [didFetchCurrentWeatherExpectation], timeout: 1)
    }
    
    func testFetchingHourlyWeather() throws {
        guard let city else {
            XCTFail("Need a city")
            return
        }
        
        let didFetchHourlyWeatherExpectation = self.expectation(description: "Did fetch hourly weather")

        engine?.weatherService.fetchHourlyWeather(city: city, completion: { forecast, error in
            XCTAssertNil(error)
            XCTAssertNotNil(forecast)

            XCTAssertNotNil(forecast?.list)
            XCTAssertNotNil(forecast?.city)
            
            XCTAssertFalse((forecast?.list ?? []).isEmpty)

            didFetchHourlyWeatherExpectation.fulfill()
        })
        
        wait(for: [didFetchHourlyWeatherExpectation], timeout: 1)
    }
    
    func testComputingDailyForecast() throws {
        guard let city else {
            XCTFail("Need a city")
            return
        }
        
        let didFetchHourlyWeatherExpectation = self.expectation(description: "Did fetch hourly weather")

        engine?.weatherService.fetchHourlyWeather(city: city, completion: { forecast, error in
            XCTAssertNil(error)
            XCTAssertNotNil(forecast)

            guard let dailyForecast = self.engine?.weatherService.dailyForecastWeatherByCity[city] else {
                XCTFail("No dailyForecast for this city")
                return
            }
            
            XCTAssertFalse(dailyForecast.dailies.isEmpty)
            
            didFetchHourlyWeatherExpectation.fulfill()
        })
        
        wait(for: [didFetchHourlyWeatherExpectation], timeout: 1)
    }

    func testDecodingCurrentWeather() throws {
        let bundle = Bundle(for: Self.self)
        let path = try XCTUnwrap(bundle.path(forResource: "CurrentWeather", ofType: "json"))
        let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)

        let jsonData = try XCTUnwrap(string.data(using: .utf8))
        
        do {
            let current = try JSONDecoder.snakeDecoder.decode(Current.self, from: jsonData)
            
            XCTAssertNotNil(current.dt)
            XCTAssertNotNil(current.main)
            XCTAssertNotNil(current.coord)
            XCTAssertNotNil(current.weather)
            
            XCTAssertNotNil(current.weather?.first)
        } catch _ {
            XCTFail("Decoding Current fails")
        }
    }
    
    func testDecodingHourlyWeather() throws {
        let bundle = Bundle(for: Self.self)
        let path = try XCTUnwrap(bundle.path(forResource: "HourlyWeather", ofType: "json"))
        let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)

        let jsonData = try XCTUnwrap(string.data(using: .utf8))
        
        do {
            let forecast = try JSONDecoder.snakeDecoder.decode(Forecast.self, from: jsonData)
            
            XCTAssertNotNil(forecast.city)

            let list = try XCTUnwrap(forecast.list)
            
            XCTAssertFalse(list.isEmpty)
        } catch _ {
            XCTFail("Decoding Forecast fails")
        }
    }

}
