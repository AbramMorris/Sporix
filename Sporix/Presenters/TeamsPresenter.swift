//
//  TeamsPresenter.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import Foundation

final class TeamsPresenter {
    private weak var view: TeamsViewProtocol?
    private let repository: TeamRepositoryProtocol
    private let sportType: SportType

    init(view: TeamsViewProtocol, repository: TeamRepository, sportType: SportType) {
        self.view = view
        self.repository = repository
        self.sportType = sportType
    }

    func fetchData(leagueId: Int) {
        repository.getTeamsOrPlayers(leagueId: leagueId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    print("success")
                    if self.sportType.isTennis, let players = data as? [TennisPlayer] {
                        self.view?.showTennisPlayers(players)
                        
                    } else if let teams = data as? [Team] {
                        self.view?.showTeams(teams)
                    } else {
                        self.view?.showError("Unknown data type")
                    }
                case .failure(let error):
                    print("fail")
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
