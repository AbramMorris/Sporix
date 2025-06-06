//
//  TeamRepository.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

class TeamRepository {
    private let api: TeamAPI

    init(api: TeamAPI) {
        self.api = api
    }

    func getTeamsOrPlayers(leagueId: Int, completion: @escaping (Result<[Any], Error>) -> Void) {
        api.fetchTeamsOrPlayers(leagueId: leagueId) { result in
            completion(result)
        }
    }
}
