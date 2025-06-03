//
//  FixturesViewProtocol.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

protocol FixturesViewProtocol: AnyObject {
    func showUpcomingFixtures(_ fixtures: [Fixture])
    func showRecentFixtures(_ fixtures: [Fixture])
    func showError(_ message: String)
}
