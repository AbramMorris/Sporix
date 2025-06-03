//
//  Events.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

struct Fixture: Decodable {
    let eventDate: String
    let eventTime: String
    let eventHomeTeam: String
    let eventAwayTeam: String
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventFinalResult: String?
}
    
struct FixturesResponse: Decodable {
    let success: Int
    let result: [Fixture]
}
