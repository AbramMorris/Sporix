//
//  FakeNetworkServices.swift
//  Sporix
//
//  Created by abram on 08/06/2025.
//
//
//  FakeNetworkService.swift
//  SporixTests
//

import Foundation
import Alamofire
@testable import Sporix

final class FakeNetworkService {

    var shouldReturnError: Bool

    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }

    func getRequest<T: Decodable>(
        url: String,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        if shouldReturnError {
            completion(.failure(AFError.explicitlyCancelled))
        } else {
            // ✅ Mock data matches your League model
            let mockJSON: [String: Any] = [
                "success": 1,
                "result": [
                    [
                        "league_key": 123,
                        "league_name": "Premier League",
                        "country_name": "England",
                        "league_logo": "https://example.com/logo.png"
                    ]
                ]
            ]

            do {
                let data = try JSONSerialization.data(withJSONObject: mockJSON)
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
            }
        }
    }
}
