//
//  FavoritesPresenter.swift
//  Sporix
//
//  Created by User on 02/06/2025.
//

import Foundation

final class FavoritesPresenter {
    
    private weak var view: FavoritesViewProtocol?
    private let repository: FavRepository

    init(view: FavoritesViewProtocol, repository: FavRepository = FavRepository()) {
        self.view = view
        self.repository = repository
    }

    func loadFavorites() {
        let favs = repository.getFavorites()
        view?.showFavorites(favs)
    }

    func addFavorite(_ fav: Fav) {
        repository.addFavorite(fav)
        loadFavorites()
    }

    func deleteFavorite(by id: Int) {
        repository.deleteFavorite(id: id)
        loadFavorites()
    }
}

