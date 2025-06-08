//
//  FixtureRepository.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

protocol FixtureRepositoryProtocol {
    func getUpcomingFixtures(leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getRecentFixtures(leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
}

final class FixtureRepository: FixtureRepositoryProtocol {
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
