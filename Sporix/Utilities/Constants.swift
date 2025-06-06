//
//  Constants.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//


import Foundation

enum SportType: String {
    case football
    case basketball
    case cricket
    case tennis

    var baseURL: String {
        return "https://apiv2.allsportsapi.com/\(self.rawValue)/"
    }
    var isTennis: Bool {
        self == .tennis
    }
}

enum APIEndpoint: String {
    case leagues = "Leagues"
    case fixtures = "Fixtures"
    case livescore = "Livescore"

    var key: String {
        return rawValue
    }
}

struct Constants {

    struct API {
        static let apiKey = "093ffc8992aca57429c7bfc95d800ed3f2065a649b8212ab62a3052c646754d4"

        static func parameters(for endpoint: APIEndpoint) -> [String: Any] {
            return [
                "met": endpoint.key,
                "APIkey": apiKey
            ]
        }
    }
}
