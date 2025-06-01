//
//  LeaguesViewProtocol.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLeagues(_ leagues: [League])
    func showError(_ message: String)
}

