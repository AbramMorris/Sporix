//
//  NetworkService.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation
import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func getRequest<T: Decodable>(url: String,
                                  parameters: [String: Any]? = nil,
                                  headers: HTTPHeaders? = nil,
                                  completion: @escaping (Result<T, AFError>) -> Void) {
        
        AF.request(url, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
