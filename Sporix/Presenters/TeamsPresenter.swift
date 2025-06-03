//
//  TeamsPresenter.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

final class TeamsPresenter {
    private weak var view: TeamsViewProtocol?
    private let repository: TeamRepository

    init(view: TeamsViewProtocol, repository: TeamRepository) {
        self.view = view
        self.repository = repository
    }

    func fetchTeams(leagueId: Int) {
        repository.getTeams(leagueId: leagueId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    self?.view?.showTeams(teams)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
