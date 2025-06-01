//
//  LeagueAPI.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation
import Alamofire

final class LeagueAPI {
    
    private let baseURL = "https://apiv2.allsportsapi.com/football/"
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchAllLeagues(completion: @escaping (Result<[League], Error>) -> Void) {
        let parameters: [String: Any] = [
            "met": "Leagues",
            "APIkey": apiKey
        ]

        NetworkService.shared.getRequest(url: baseURL, parameters: parameters) { (result: Result<LeaguesResponse, AFError>) in
            switch result {
            case .success(let response):
                if response.success == 1 {
                    completion(.success(response.result))
                } else {
                    let error = NSError(domain: "LeagueAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch leagues"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
