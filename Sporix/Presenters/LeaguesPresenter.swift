//
//  Presenters.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import Foundation

final class LeaguesPresenter {
    private weak var view: LeaguesViewProtocol?
    private let repository: LeagueRepository

    init(view: LeaguesViewProtocol, repository: LeagueRepository) {
        self.view = view
        self.repository = repository
    }

    func fetchLeagues() {
        repository.getAllLeagues { [weak self] result in
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
