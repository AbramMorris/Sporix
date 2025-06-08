//
//  Presenters.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation

final class LeaguesPresenter {
    
    private weak var view: LeaguesViewProtocol?
    private let leagueRepository: LeagueRepositoryProtocol

    init(view: LeaguesViewProtocol, leagueRepository : LeagueRepository) {
        self.view = view
        self.leagueRepository = leagueRepository
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
}
