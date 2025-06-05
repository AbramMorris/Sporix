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
    let players: [Player]?
    let coaches: [Coach]?

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
        case coaches
    }
}


struct TeamsResponse: Decodable {
    let success: Int
    let result: [Team]
}

struct Player: Decodable {
    let playerKey: Int
    let playerName: String
    let playerNumber: String?
    let playerCountry: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerImage: String?

    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerCountry = "player_country"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerGoals = "player_goals"
        case playerImage = "player_image"
    }
}

struct Coach: Decodable {
    let coachName: String
    let coachCountry: String?
    let coachAge: String?

    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
        case coachCountry = "coach_country"
        case coachAge = "coach_age"
    }
}
struct TeamMember {
    let name: String
    let imageURL: String
    let position: String
    let jerseyNumber: String
    let nationality: String
}
