//
//  FixturesPresenter.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

final class FixturesPresenter {
    private weak var view: FixturesViewProtocol?
    private let repository: FixtureRepositoryProtocol

    init(view: FixturesViewProtocol, repository: FixtureRepository) {
        self.view = view
        self.repository = repository
    }

    func fetchUpcomingFixtures(leagueId: Int) {
        repository.getUpcomingFixtures(leagueId: leagueId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fixtures):
                    self?.view?.showUpcomingFixtures(fixtures)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    func fetchRecentFixtures(leagueId: Int) {
        repository.getRecentFixtures(leagueId: leagueId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fixtures):
                    self?.view?.showRecentFixtures(fixtures)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
