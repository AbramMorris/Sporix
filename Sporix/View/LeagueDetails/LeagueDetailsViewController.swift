//
//  LeagueDetailsViewController.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    
    @IBOutlet weak var leaguePhoto: UIImageView!
    @IBOutlet weak var CountryName: UILabel!
    @IBOutlet weak var teamsName: UILabel!
    @IBOutlet weak var recentCollection: UICollectionView!
    @IBOutlet weak var upComingCollection: UICollectionView!
    @IBOutlet weak var teamsCollection: UICollectionView!
    @IBOutlet weak var legueName: UILabel!
    
    // MARK: - Public Vars (set before push)
    var leagueId: Int?
    var leagueNameText: String?
    var countryNameText: String?
    var leagueLogoURL: String?
    var sportType: SportType = .football
    
    // MARK: - Private Vars
    private var fixturesPresenter: FixturesPresenter!
    private var teamsPresenter: TeamsPresenter!
    
    private var recentFixtures: [Fixture] = []
    private var upcomingFixtures: [Fixture] = []
    private var teams: [Team] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fixturesPresenter = FixturesPresenter(view: self, repository: FixtureRepository(api: FixtureAPI(sportType: sportType)))
        teamsPresenter = TeamsPresenter(view: self, repository: TeamRepository(api: TeamAPI(sportType: sportType)))
        
        setupCollections()
        displayBasicInfo()
        fetchAllData()
    }
    
    private func displayBasicInfo() {
        legueName.text = leagueNameText
        CountryName.text = countryNameText
        
        if let logoURL = leagueLogoURL, let url = URL(string: logoURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.leaguePhoto.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    private func fetchAllData() {
        guard let leagueId = leagueId else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let toDate = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        
        fixturesPresenter.fetchFixtures(
            leagueId: leagueId,
            from: formatter.string(from: fromDate),
            to: formatter.string(from: toDate)
        )
        
        teamsPresenter.fetchTeams(leagueId: leagueId)
    }
    
    private func setupCollections() {
        recentCollection.dataSource = self
        recentCollection.delegate = self
        upComingCollection.dataSource = self
        upComingCollection.delegate = self
        teamsCollection.dataSource = self
        teamsCollection.delegate = self
    }
}

// MARK: - FixturesViewProtocol
extension LeagueDetailsViewController: FixturesViewProtocol {
    func showFixtures(_ fixtures: [Fixture]) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        recentFixtures = fixtures.filter {
            guard let date = formatter.date(from: $0.eventDate) else { return false }
            return date < now
        }.sorted { $0.eventDate > $1.eventDate }
        
        upcomingFixtures = fixtures.filter {
            guard let date = formatter.date(from: $0.eventDate) else { return false }
            return date >= now
        }.sorted { $0.eventDate < $1.eventDate }
        
        recentCollection.reloadData()
        upComingCollection.reloadData()
    }

    func showError(_ message: String) {
        print("Fixtures error: \(message)")
    }
}

// MARK: - TeamsViewProtocol
extension LeagueDetailsViewController: TeamsViewProtocol {
    func showTeams(_ teams: [Team]) {
        self.teams = teams
        teamsCollection.reloadData()
    }

//    func showError(_ message: String) {
//        print("Teams error: \(message)")
//    }
}

// MARK: - UICollectionView DataSource/Delegate
extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentCollection {
            return recentFixtures.count
        } else if collectionView == upComingCollection {
            return upcomingFixtures.count
        } else {
            return teams.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath)
            // TODO: Cast to custom cell and configure
            return cell
        } else if collectionView == upComingCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath)
            // TODO: Cast to custom cell and configure
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath)
            // TODO: Cast to custom cell and configure
            return cell
        }
    }
}
