//
//  LeagueFavMapper.swift
//  Sporix
//
//  Created by User on 03/06/2025.
//

import Foundation

final class LeagueFavMapper {
    
    static func mapToFav(from league: League, sportType: String) -> Fav {
        return Fav(
            id: league.league_key,
            LeagueName: league.league_name,
            LeagueImage: league.league_logo,
            sportType: sportType
        )
    }
}
