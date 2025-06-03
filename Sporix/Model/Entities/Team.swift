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
}

struct TeamsResponse: Decodable {
    let success: Int
    let result: [Team]
}
