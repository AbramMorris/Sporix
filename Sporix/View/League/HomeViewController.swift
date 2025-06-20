//
//  HomeViewController.swift
//  Sporix
//
//  Created by abram on 31/05/2025.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController ,FavoriteDelegate{
    var passedFlag: String?

    @IBOutlet weak var leagueTableView: UITableView!
    
    private var leaguesPresenter: LeaguesPresenter!
    private var favPresenter: FavoritesPresenter!
    private var leagues: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        leagueTableView.allowsSelection = true
        setupTableView()
        setupBackButton()
        setupPresenter()
        leaguesPresenter.fetchLeagues()
    }

    private func setupPresenter() {
        let sportType = SportType(rawValue: passedFlag ?? "") ?? .football
        let api = LeagueAPI(sportType: sportType)
        let leagueRepo = LeagueRepository(api: api)
        let favRepo = FavRepository()
        leaguesPresenter = LeaguesPresenter(view: self, leagueRepository: leagueRepo)
        favPresenter = FavoritesPresenter(repository: favRepo)
    }

    private func setupTableView() {
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        leagueTableView.register(nib, forCellReuseIdentifier: "leagueCell")
        
        leagueTableView.delegate = self
        leagueTableView.dataSource = self
        leagueTableView.rowHeight = 150
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        let storyboard = UIStoryboard(name: "Sports", bundle: nil)
        if let sportsVC = storyboard.instantiateViewController(withIdentifier: "tab") as? UITabBarController {
            sportsVC.modalPresentationStyle = .fullScreen
            present(sportsVC, animated: false)
        } else {
            print("Could not cast to UITabBarController")
        }
    }
    
    func didAddToFavorites(_ league: League) {
        favPresenter.addFavorite(league,passedFlag!)
    }

    func didRemoveFromFavorites(_ league: League) {
        favPresenter.deleteFavorite(league.league_key)
    }
}

extension HomeViewController: LeaguesViewProtocol {
    func showLeagues(_ leagues: [League]) {
        self.leagues = leagues
        leagueTableView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as? LeagueTableViewCell else {
            return UITableViewCell()
        }
        
        let league = leagues[indexPath.row]
        
        cell.league = league
        cell.isFavorite = favPresenter.isFavorite(league.league_key)
        cell.delegate = self

        cell.leagueTitle.text = league.league_name
        cell.leagueCountry.text = league.country_name
        if let logoURLString = league.league_logo, let url = URL(string: logoURLString) {
            cell.leagueImage.kf.setImage(with: url, placeholder: UIImage(named: "images"))
        } else {
            cell.leagueImage.image = UIImage(named: "images")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row tapped")
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedLeague = leagues[indexPath.row]
        let storyboard = UIStoryboard(name: "LeagueDetails", bundle: nil)

        guard let navController = storyboard.instantiateViewController(withIdentifier: "LeagueDetails") as? UINavigationController,
              let leagueDetailsVC = navController.viewControllers.first as? LeagueDetailsViewController else {
            print("Could not instantiate LeagueDetails UINavigationController or root VC")
            return
        }

        leagueDetailsVC.leagueId = selectedLeague.league_key
        leagueDetailsVC.leagueNameText = selectedLeague.league_name
        leagueDetailsVC.countryNameText = selectedLeague.country_name
        leagueDetailsVC.leagueLogoURL = selectedLeague.league_logo
        leagueDetailsVC.sportType = SportType(rawValue: passedFlag ?? "") ?? .football

        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }


}


