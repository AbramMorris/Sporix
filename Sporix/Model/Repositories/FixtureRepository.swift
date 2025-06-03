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

    func getFixtures(leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        api.fetchFixtures(leagueId: leagueId, from: from, to: to, completion: completion)
    }
}
