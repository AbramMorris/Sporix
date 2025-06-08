//
//  MockNetworkManagerTests.swift
//  Sporix
//
//  Created by abram on 08/06/2025.
//
import XCTest
@testable import Sporix
import Alamofire

final class MockNetworkManagerTests: XCTestCase {

    var fakeNetwork: FakeNetworkService!

    override func setUpWithError() throws {
        fakeNetwork = FakeNetworkService(shouldReturnError: false)
    }

    override func tearDownWithError() throws {
        fakeNetwork = nil
    }

    func testGetLeaguesSuccess() {
        let expectation = expectation(description: "Leagues fetch success")

        fakeNetwork.getRequest(url: "mockURL") { (result: Result<LeaguesResponse, AFError>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.success, 1)
                XCTAssertEqual(response.result.count, 1)
                XCTAssertEqual(response.result.first?.league_name, "Premier League")
                XCTAssertEqual(response.result.first?.country_name, "England")
            case .failure:
                XCTFail("Expected success response")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testGetLeaguesFailure() {
        fakeNetwork = FakeNetworkService(shouldReturnError: true)

        let expectation = expectation(description: "Leagues fetch failure")

        fakeNetwork.getRequest(url: "mockURL") { (result: Result<LeaguesResponse, AFError>) in
            switch result {
            case .success:
                XCTFail("Expected failure response")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
