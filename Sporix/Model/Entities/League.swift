//
//  League.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation

struct League: Decodable {
    let league_key: Int
    let league_name: String
    let country_name: String?
    let league_logo: String?

    enum CodingKeys: String, CodingKey {
        case league_key = "league_key"
        case league_name = "league_name"
        case country_name = "country_name"
        case league_logo = "league_logo"
    }
}
