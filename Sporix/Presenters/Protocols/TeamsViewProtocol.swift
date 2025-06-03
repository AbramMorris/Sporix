//
//  TeamsViewProtocol.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

protocol TeamsViewProtocol: AnyObject {
    func showTeams(_ teams: [Team])
    func showError(_ message: String)
}
