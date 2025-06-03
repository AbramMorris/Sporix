//
//  FixturesViewProtocol.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation
protocol FixturesViewProtocol: AnyObject {
    func showFixtures(_ fixtures: [Fixture])
    func showError(_ message: String)
}
