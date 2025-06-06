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
        static let apiKey = "a94a2c95e018a43287adc17b5d4eae82f866034c322db2573bfec40ce79c47ae"

        static func parameters(for endpoint: APIEndpoint) -> [String: Any] {
            return [
                "met": endpoint.key,
                "APIkey": apiKey
            ]
        }
    }
}
