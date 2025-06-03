//
//  FixtureAPI.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation
import Alamofire

final class FixtureAPI {
    private let sportType: SportType

    init(sportType: SportType) {
        self.sportType = sportType
    }

    func fetchFixtures(leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let url = sportType.baseURL
        let parameters: [String: Any] = [
            "met": "Fixtures",
            "APIkey": Constants.API.apiKey,
            "leagueId": leagueId,
            "from": from,
            "to": to
        ]

        NetworkService.shared.getRequest(url: url, parameters: parameters) { (result: Result<FixturesResponse, AFError>) in
            switch result {
            case .success(let response):
                if response.success == 1 {
                    completion(.success(response.result))
                } else {
                    completion(.failure(NSError(domain: "FixtureAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch fixtures"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
