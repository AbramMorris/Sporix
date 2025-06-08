//
//  FavoritesPresenter.swift
//  Sporix
//
//  Created by User on 02/06/2025.
//

import Foundation

final class FavoritesPresenter {
    
    private weak var view: FavoritesViewProtocol?
    private let repository: FavRepositoryProtocol

    init(view: FavoritesViewProtocol, repository: FavRepository = FavRepository()) {
        self.view = view
        self.repository = repository
    }
    
    init(repository: FavRepository){
        self.repository = repository
    }

    func loadFavorites() {
        let favs = repository.getFavorites()
        view?.showFavorites(favs)
    }

    func addFavorite(_ league: League,_ sport: String){
        let fav = LeagueFavMapper.mapToFav(from: league, sportType: sport)
        repository.addFavorite(fav)
    }

    func deleteFavorite(_ id: Int) {
        repository.deleteFavorite(id: id)
        loadFavorites()
    }
    
    func isFavorite(_ leagueId: Int) -> Bool {
        return repository.isFavExist(id: leagueId)
    }
    
}

