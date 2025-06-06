//
//  Events.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

struct FixturesResponse: Decodable {
    let success: Int?
    let result: [Fixture]
    
    private enum CodingKeys: String, CodingKey {
        case success
        case result
    }
}

struct Fixture: Decodable {
    let eventDate: String
    let eventTime: String
    let eventHomeTeam: String
    let eventAwayTeam: String
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventFinalResult: String?

    private enum CodingKeys: String, CodingKey {
        case eventDate = "event_date"
        case eventDateStart = "event_date_start"
        case eventTime = "event_time"
        
        case eventHomeTeam = "event_home_team"
        case eventFirstPlayer = "event_first_player"
        
        case eventAwayTeam = "event_away_team"
        case eventSecondPlayer = "event_second_player"
        
        case homeTeamLogo = "home_team_logo"
        case eventHomeTeamLogo = "event_home_team_logo"
        case eventFirstPlayerLogo = "event_first_player_logo"
        
        case awayTeamLogo = "away_team_logo"
        case eventAwayTeamLogo = "event_away_team_logo"
        case eventSecondPlayerLogo = "event_second_player_logo"
        
        case eventFinalResult = "event_final_result"
        case eventHomeFinalResult = "event_home_final_result"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let date = try? container.decode(String.self, forKey: .eventDate) {
            self.eventDate = date
        } else if let date = try? container.decode(String.self, forKey: .eventDateStart) {
            self.eventDate = date
        } else {
            self.eventDate = ""
        }

        self.eventTime = (try? container.decode(String.self, forKey: .eventTime)) ?? ""

        if let homeTeam = try? container.decode(String.self, forKey: .eventHomeTeam) {
            self.eventHomeTeam = homeTeam
        } else if let homeTeam = try? container.decode(String.self, forKey: .eventFirstPlayer) {
            self.eventHomeTeam = homeTeam
        } else {
            self.eventHomeTeam = ""
        }

        if let awayTeam = try? container.decode(String.self, forKey: .eventAwayTeam) {
            self.eventAwayTeam = awayTeam
        } else if let awayTeam = try? container.decode(String.self, forKey: .eventSecondPlayer) {
            self.eventAwayTeam = awayTeam
        } else {
            self.eventAwayTeam = ""
        }

        self.homeTeamLogo =
            (try? container.decode(String.self, forKey: .homeTeamLogo)) ??
            (try? container.decode(String.self, forKey: .eventHomeTeamLogo)) ??
            (try? container.decode(String.self, forKey: .eventFirstPlayerLogo))

        self.awayTeamLogo =
            (try? container.decode(String.self, forKey: .awayTeamLogo)) ??
            (try? container.decode(String.self, forKey: .eventAwayTeamLogo)) ??
            (try? container.decode(String.self, forKey: .eventSecondPlayerLogo))

        self.eventFinalResult =
            (try? container.decode(String.self, forKey: .eventFinalResult)) ??
            (try? container.decode(String.self, forKey: .eventHomeFinalResult))
    }
}
