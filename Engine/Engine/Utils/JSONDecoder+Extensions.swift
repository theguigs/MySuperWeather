//
//  JSONDecoder+Extensions.swift
//  Engine
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import Foundation

extension JSONDecoder {
    static var snakeDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
