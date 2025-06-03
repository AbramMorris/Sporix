//
//  FavRepository.swift
//  Sporix
//
//  Created by User on 02/06/2025.
//

import Foundation

class FavRepository {
    
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
