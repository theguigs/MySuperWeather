//
//  CitiesServiceTests.swift
//  EngineTests
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import XCTest
import Engine

final class CitiesServiceTests: XCTestCase {

    var engine: Engine?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let baseURL = URL(string: "https://api.openweathermap.org") else {
            XCTFail("Base URL is not a valid URL")
            return
        }

        let network = EngineConfiguration.Network(baseUrl: baseURL)
        let configuration = EngineConfiguration(network: network)
        
        self.engine = Engine(configuration: configuration)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingCitiesWithResult() throws {
        XCTAssertNotNil(engine)
        
        let didFetchCitiesExpectation = self.expectation(description: "Did fetch cities")

        self.engine?.citiesService.fetchCities(for: "Paris", completion: { cities, error in
            XCTAssertNil(error)
            XCTAssertNotNil(cities)
            XCTAssertTrue((cities ?? []).count > 0)
            didFetchCitiesExpectation.fulfill()
        })
        
        wait(for: [didFetchCitiesExpectation], timeout: 1)
    }
    
    func testFetchingCitiesNoResult() throws {
        XCTAssertNotNil(engine)
        
        let didFetchCitiesExpectation = self.expectation(description: "Did fetch cities")

        self.engine?.citiesService.fetchCities(for: "No Result", completion: { cities, error in
            XCTAssertNil(error)
            XCTAssertNotNil(cities)
            XCTAssertTrue((cities ?? []).count == 0)
            didFetchCitiesExpectation.fulfill()
        })
        
        wait(for: [didFetchCitiesExpectation], timeout: 1)
    }
    
    func testCitiesCache() throws {
        XCTAssertNotNil(engine)
        
        let didFetchCitiesExpectation = self.expectation(description: "Did fetch cities")

        self.engine?.citiesService.fetchCities(for: "Paris", completion: { cities, error in
            XCTAssertNil(error)
            XCTAssertNotNil(cities)
            
            guard let city = cities?.first else { return }
            
            self.engine?.citiesService.cities.append(city)
            
            self.engine?.citiesService.readCitiesFromCache { succeed in
                XCTAssertTrue(succeed)
            }
            
            self.engine?.citiesService.deleteCitiesCache()
            
            self.engine?.citiesService.readCitiesFromCache { succeed in
                XCTAssertFalse(succeed)
            }

            didFetchCitiesExpectation.fulfill()
        })
        
        wait(for: [didFetchCitiesExpectation], timeout: 2)
    }

    func testDecodingGeocodedCity() throws {
        let bundle = Bundle(for: Self.self)
        let path = try XCTUnwrap(bundle.path(forResource: "GeocodedCity", ofType: "json"))
        let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)

        let jsonData = try XCTUnwrap(string.data(using: .utf8))
        
        do {
            let city = try JSONDecoder.snakeDecoder.decode(GeocodedCity.self, from: jsonData)
            
            XCTAssertNotNil(city.name)

            XCTAssertNotNil(city.lat)
            XCTAssertNotNil(city.lon)
            
            XCTAssertNotNil(city.state)
            XCTAssertNotNil(city.localNames)
        } catch _ {
            XCTFail("Decoding GeocodedCity fails")
        }
    }
}
