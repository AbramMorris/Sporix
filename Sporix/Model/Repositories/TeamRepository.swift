//
//  TeamRepository.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

final class TeamRepository {
    private let api: TeamAPI

    init(api: TeamAPI) {
        self.api = api
    }

    func getTeams(leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        api.fetchTeams(leagueId: leagueId, completion: completion)
    }
}
