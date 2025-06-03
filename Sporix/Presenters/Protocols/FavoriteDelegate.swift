//
//  FavoriteDelegate.swift
//  Sporix
//
//  Created by User on 03/06/2025.
//

import Foundation

protocol FavoriteDelegate: AnyObject {
    func didAddToFavorites(_ league: League)
    func didRemoveFromFavorites(_ league: League)
}

