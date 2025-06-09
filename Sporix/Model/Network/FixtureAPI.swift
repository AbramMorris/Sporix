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


    func fetchUpcomingFixtures(leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let today = Date()
                let oneYearLater = Calendar.current.date(byAdding: .year, value: 1, to: today)!

                let from = DateFormatter.yyyyMMdd.string(from: today)
                let to = DateFormatter.yyyyMMdd.string(from: oneYearLater)


        fetchFixtures(leagueId: leagueId, from: from, to: to, completion: completion)
    }

    func fetchRecentFixtures(leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let today = Date()
               let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today)!

               let from = DateFormatter.yyyyMMdd.string(from: oneYearAgo)
               let to = DateFormatter.yyyyMMdd.string(from: today)

        fetchFixtures(leagueId: leagueId, from: from, to: to, completion: completion)
    }

    private func fetchFixtures(leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let url = sportType.baseURL
        var parameters: [String: Any] = [
            "met": "Fixtures",
            "APIkey": Constants.API.apiKey,
            "leagueId": leagueId,
            "from": from,
            "to": to
        ]
        if self.sportType == .tennis {
            var newParameters: [String: Any] = [:]
            newParameters["met"] = "Fixtures"
            newParameters["APIkey"] = Constants.API.apiKey
            newParameters["from"] = from
            newParameters["to"] = to
            newParameters["leagueId"] = leagueId
            parameters = newParameters
        }

        NetworkService.shared.getRequest(url: url, parameters: parameters) { (result: Result<FixturesResponse, AFError>) in
            switch result {
            case .success(let response):
                print("fixtures success")
                if response.success == 1 {
                    completion(.success(response.result))
                } else {
                    completion(.failure(NSError(domain: "FixtureAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch fixtures"])))
                }
            case .failure(let error):
                print("fixtures failure")
                completion(.failure(error))
            }
        }
    }
}
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
