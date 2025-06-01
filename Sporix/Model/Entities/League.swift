//
//  League.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation

struct League: Decodable {
    let league_key: Int
    let league_name: String
    let country_name: String?
    let league_logo: String?
}
