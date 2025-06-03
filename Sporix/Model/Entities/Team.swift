//
//  Team.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

struct Team: Decodable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String?

    private enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}


struct TeamsResponse: Decodable {
    let success: Int
    let result: [Team]
}
