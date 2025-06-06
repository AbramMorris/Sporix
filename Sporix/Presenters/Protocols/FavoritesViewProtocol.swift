//
//  FavoritesViewProtocol.swift
//  Sporix
//
//  Created by User on 02/06/2025.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func showFavorites(_ favorites: [Fav])
    func showError(_ message: String)
}

