//
//  FixtureRepository.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

final class FixtureRepository {
    private let api: FixtureAPI

    init(api: FixtureAPI) {
        self.api = api
    }

    func getUpcomingFixtures(leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        api.fetchUpcomingFixtures(leagueId: leagueId, completion: completion)
    }

    func getRecentFixtures(leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        api.fetchRecentFixtures(leagueId: leagueId, completion: completion)
    }
}
