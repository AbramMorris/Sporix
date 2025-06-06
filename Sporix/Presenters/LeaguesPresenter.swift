//
//  Presenters.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation

final class LeaguesPresenter {
    
    private weak var view: LeaguesViewProtocol?
    private let leagueRepository: LeagueRepository
    private let favRepository: FavRepository

    init(view: LeaguesViewProtocol, leagueRepository : LeagueRepository, favRepository : FavRepository) {
        self.view = view
        self.leagueRepository = leagueRepository
        self.favRepository = favRepository
    }

    func fetchLeagues() {
        leagueRepository.getAllLeagues { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let leagues):
                    self?.view?.showLeagues(leagues)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func addLeagueToFavorites(_ league: League,_ sport: String) {
           let fav = LeagueFavMapper.mapToFav(from: league, sportType: sport)
           favRepository.addFavorite(fav)
       }

       func removeLeagueFromFavorites(_ league: League) {
           favRepository.deleteFavorite(id: league.league_key)
       }

       func isFavorite(_ leagueId: Int) -> Bool {
           return favRepository.isFavExist(id: leagueId)
       }
    
}
