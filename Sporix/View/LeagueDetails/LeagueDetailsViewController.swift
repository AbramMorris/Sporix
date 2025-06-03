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

    var leagueId: Int?
    var leagueNameText: String?
    var countryNameText: String?
    var leagueLogoURL: String?
    var sportType: SportType = .football

    private var fixturesPresenter: FixturesPresenter!
    private var teamsPresenter: TeamsPresenter!

    @IBOutlet weak var scrolll: UIScrollView!
    private var recentFixtures: [Fixture] = []
    private var upcomingFixtures: [Fixture] = []
    private var teams: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        scrolll.bounces = false
        scrolll.alwaysBounceHorizontal = false
        scrolll.alwaysBounceVertical = true
        let fixtureNib = UINib(nibName: "FixtureCollectionViewCell", bundle: nil)
               recentCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")
               upComingCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")
        teamsCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TeamCell")

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

        fixturesPresenter.fetchUpcomingFixtures(leagueId: leagueId)
        fixturesPresenter.fetchRecentFixtures(leagueId: leagueId)
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

extension LeagueDetailsViewController: FixturesViewProtocol {
    func showUpcomingFixtures(_ fixtures: [Fixture]) {
        self.upcomingFixtures = fixtures
        self.upComingCollection.reloadData()
    }

    func showRecentFixtures(_ fixtures: [Fixture]) {
        self.recentFixtures = fixtures
        self.recentCollection.reloadData()
    }

    func showError(_ message: String) {
        print("Fixtures error: \(message)")
    }
}

extension LeagueDetailsViewController: TeamsViewProtocol {
    func showTeams(_ teams: [Team]) {
        self.teams = teams
        self.teamsCollection.reloadData()
    }
}

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath) as! FixtureCollectionViewCell
            let fixture = recentFixtures[indexPath.row]
            cell.team1Name.text = fixture.eventHomeTeam
            cell.team2Name.text = fixture.eventAwayTeam
            cell.matchResult.text = fixture.eventFinalResult ?? "-"
            cell.matchDate.text = fixture.eventDate
            cell.matchTime.text = fixture.eventTime
            loadImage(urlStr: fixture.homeTeamLogo, into: cell.teamImage1)
            loadImage(urlStr: fixture.awayTeamLogo, into: cell.teamImage2)
            return cell

        } else if collectionView == upComingCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath) as! FixtureCollectionViewCell
            let fixture = upcomingFixtures[indexPath.row]
            cell.team1Name.text = fixture.eventHomeTeam
            cell.team2Name.text = fixture.eventAwayTeam
            cell.matchDate.text = fixture.eventDate
            cell.matchTime.text = fixture.eventTime
            cell.matchResult.text = nil
            loadImage(urlStr: fixture.homeTeamLogo, into: cell.teamImage1)
            loadImage(urlStr: fixture.awayTeamLogo, into: cell.teamImage2)
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath)
            if let label = cell.contentView.viewWithTag(102) as? UILabel {
                label.text = teams[indexPath.row].teamName
            }
            return cell
        }
    }

    private func loadImage(urlStr: String?, into imageView: UIImageView) {
        imageView.image = nil
        guard let urlStr = urlStr, let url = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

extension LeagueDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 400, height: 250)
    }
}
