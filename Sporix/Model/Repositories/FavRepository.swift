//
//  FavRepository.swift
//  Sporix
//
//  Created by User on 02/06/2025.
//

import Foundation

protocol FavRepositoryProtocol {
    func getFavorites() -> [Fav]
    func addFavorite(_ fav: Fav)
    func deleteFavorite(id: Int)
    func isFavExist(id: Int) -> Bool
}

final class FavRepository: FavRepositoryProtocol {

    func getFavorites() -> [Fav] {
        return DatabaseManager.shared.getAllFavs()
    }
    
    func addFavorite(_ fav: Fav) {
        DatabaseManager.shared.saveFav(fav)
    }
    
    func deleteFavorite(id: Int) {
        DatabaseManager.shared.deleteFav(withId: id)
    }
    
    func isFavExist(id: Int) -> Bool {
        return DatabaseManager.shared.isFavExist(id: id)
    }
    
}
