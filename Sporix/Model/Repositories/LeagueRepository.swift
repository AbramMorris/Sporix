//
//  LeagueRepository.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation


final class LeagueRepository {
    private let api: LeagueAPI

    init(api: LeagueAPI) {
        self.api = api
    }

    func getAllLeagues(completion: @escaping (Result<[League], Error>) -> Void) {
        api.fetchAllLeagues(completion: completion)
    }
}
