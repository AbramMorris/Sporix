//
//  SporixTests.swift
//  SporixTests
//
//  Created by User on 28/05/2025.
//

import XCTest
@testable import Sporix
import Alamofire

final class SporixTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkServiceGetRequest() {
        let expectation = self.expectation(description: "Fetch leagues API completes")

        let sport = SportType.football
        let endpoint = APIEndpoint.leagues
        let url = sport.baseURL
        var parameters = Constants.API.parameters(for: endpoint)
        parameters["sport"] = sport.rawValue

        NetworkService.shared.getRequest(url: url, parameters: parameters) { (result: Result<LeaguesResponse, AFError>) in
            switch result {
            case .success(let leaguesResponse):
                XCTAssertEqual(leaguesResponse.success, 1, "API success flag should be 1")
                XCTAssertFalse(leaguesResponse.result.isEmpty, "Result should not be empty")
                if let firstLeague = leaguesResponse.result.first {
                    XCTAssertFalse(firstLeague.league_name.isEmpty, "League name should not be empty")
                }
            case .failure(let error):
                print("API call failed with error: \(error.localizedDescription)")
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 15)
    }

}
