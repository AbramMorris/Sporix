//
//  FixturesPresenter.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

final class FixturesPresenter {
    private weak var view: FixturesViewProtocol?
    private let repository: FixtureRepository

    init(view: FixturesViewProtocol, repository: FixtureRepository) {
        self.view = view
        self.repository = repository
    }

    func fetchFixtures(leagueId: Int, from: String, to: String) {
        repository.getFixtures(leagueId: leagueId, from: from, to: to) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fixtures):
                    self?.view?.showFixtures(fixtures)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
