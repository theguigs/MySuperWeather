//
//  WeatherService.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

public class WeatherService {
    let p = "/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}"
    let apiKey = "a94c1fc3752fe051f7e56ced4315a1cb"
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func fetchData(completion: @escaping (Welcome?, Error?) -> Void) {
        let dict: [String: Any] = [
            "lat": 48.856613,
            "lon": 2.352222,
            "appid": "a94c1fc3752fe051f7e56ced4315a1cb"
        ]
        
        networkClient.call(
            endpoint: WeatherEndpoints.onecall,
            dict: dict,
            parameterEncoding: .URL
        ) { result in
            switch result {
                case .success((let data, let statusCode)):
                    do {
                        let welcome = try JSONDecoder.snakeDecoder.decode(Welcome.self, from: data)
                        completion(welcome, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                case .failure(let failure):
                    print(failure)
            }
        }
    }
}
