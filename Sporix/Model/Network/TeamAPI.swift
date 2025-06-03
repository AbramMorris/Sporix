//
//  TeamAPI.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation
import Alamofire

final class TeamAPI {
    private let sportType: SportType

    init(sportType: SportType) {
        self.sportType = sportType
    }

    func fetchTeams(leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        let url = sportType.baseURL
        let parameters: [String: Any] = [
            "met": "Teams",
            "APIkey": Constants.API.apiKey,
            "leagueId": leagueId
        ]

        NetworkService.shared.getRequest(url: url, parameters: parameters) { (result: Result<TeamsResponse, AFError>) in
            switch result {
            case .success(let response):
                if response.success == 1 {
                    completion(.success(response.result))
                } else {
                    completion(.failure(NSError(domain: "TeamAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch teams"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
