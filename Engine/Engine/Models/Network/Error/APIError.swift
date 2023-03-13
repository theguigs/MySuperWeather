//
//  APIError.swift
//  Engine
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import Foundation

public enum APIError: Error {
    case missingParam
    case unexpectedAPIResponse
    case requestFailure
    
    public var localizedDescription: String {
        switch self {
            case .missingParam:
                return "Une erreur est survenue, veuillez contacter un administrateur"
            case .unexpectedAPIResponse:
                return "Réponse serveur inattendue"
            case .requestFailure:
                return "La requête a échouée"
        }
    }
}
