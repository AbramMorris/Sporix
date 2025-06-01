//
//  HomeViewController.swift
//  Sporix
//
//  Created by abram on 31/05/2025.
//
//
//  HomeViewController.swift
//  Sporix
//
//  Created by abram on 31/05/2025.
//

import UIKit
import Kingfisher


class HomeViewController: UIViewController {

    @IBOutlet weak var leagueCollectionView: UICollectionView!
    
    private var presenter: LeaguesPresenter!
    private var leagues: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBackButton()
        setupPresenter()
        presenter.fetchLeagues()
    }
    
    private func setupPresenter() {
        let api = LeagueAPI(
        apiKey:"093ffc8992aca57429c7bfc95d800ed3f2065a649b8212ab62a3052c646754d4")
        let repo = LeagueRepository(api: api)
        presenter = LeaguesPresenter(view: self, repository: repo)
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        leagueCollectionView.register(nib, forCellWithReuseIdentifier: "leagueCell")
        
        leagueCollectionView.delegate = self
        leagueCollectionView.dataSource = self
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
        let storyboard = UIStoryboard(name: "Sports", bundle: nil)
        if let sportsVC = storyboard.instantiateViewController(withIdentifier: "tab") as? UITabBarController {
            sportsVC.modalPresentationStyle = .fullScreen
            present(sportsVC, animated: false)
        } else {
            print("Could not cast to HomeViewController")
        }
    }
}

extension HomeViewController: LeaguesViewProtocol {
    func showLeagues(_ leagues: [League]) {
        self.leagues = leagues
        leagueCollectionView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


// MARK: - UICollectionViewDataSource & Delegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 150
        )
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }

        let league = leagues[indexPath.item]
        cell.leagueTitle.text = league.league_name
        cell.leagueCountry.text = league.country_name
        if let logoURLString = league.league_logo, let url = URL(string: logoURLString) {
            cell.leagueImage.kf.setImage(with: url, placeholder: UIImage(named: "image"))
        } else {
            cell.leagueImage.image = UIImage(named: "image")
        }

        return cell
    }
}
