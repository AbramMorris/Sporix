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

    func fetchTeamsOrPlayers(leagueId: Int, completion: @escaping (Result<[Any], Error>) -> Void) {
        let url = sportType.baseURL
        let method = sportType.isTennis ? "Players" : "Teams"

        let parameters: [String: Any] = [
            "met": method,
            "APIkey": Constants.API.apiKey,
            "leagueId": leagueId
        ]
        let TennisParameters: [String: Any] = [
            "met": "Players",
            "leagueId": leagueId,
            "APIkey": Constants.API.apiKey
        ]

        print("Fetching from URL: \(url) with parameters: \(parameters)")

        if sportType.isTennis {
            NetworkService.shared.getRequest(url: "https://apiv2.allsportsapi.com/tennis/", parameters: TennisParameters) { (result: Result<PlayersResponse, AFError>) in
                switch result {
                case .success(let response):
                    print("Sucsess Tennis Players: \(response.result)")
                    if response.success == 1 {
                        completion(.success(response.result))
                    } else {
                        completion(.failure(NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Tennis Players"])))
                    }
                case .failure(let error):
                    print("faillllll\(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        } else {
            NetworkService.shared.getRequest(url: url, parameters: parameters) { (result: Result<TeamsResponse, AFError>) in
                switch result {
                case .success(let response):
                    if response.success == 1 {
                        completion(.success(response.result))
                    } else {
                        completion(.failure(NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Teams"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
