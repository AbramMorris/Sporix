//
//  LeagueDetailsViewController.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import UIKit
import Kingfisher

class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var teamsLabel: UILabel!
    @IBOutlet weak var leaguePhoto: UIImageView!
    @IBOutlet weak var CountryName: UILabel!
    @IBOutlet weak var teamsName: UILabel!
    @IBOutlet weak var recentCollection: UICollectionView!
    @IBOutlet weak var upComingCollection: UICollectionView!
    @IBOutlet weak var teamsCollection: UICollectionView!
    @IBOutlet weak var legueName: UILabel!
    @IBOutlet weak var scrolll: UIScrollView!

    var leagueId: Int?
    var leagueNameText: String?
    var countryNameText: String?
    var leagueLogoURL: String?
    var sportType: SportType?

    private var fixturesPresenter: FixturesPresenter!
    private var teamsPresenter: TeamsPresenter!

    private var recentFixtures: [Fixture] = []
    private var upcomingFixtures: [Fixture] = []

    private var teams: [Team] = []
    private var players: [TennisPlayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        print("sports Name:\(sportType ?? .football)")
        let fixtureNib = UINib(nibName: "FixtureCollectionViewCell", bundle: nil)
        recentCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")
        upComingCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")

        let teamNib = UINib(nibName: "TeamsCollectionViewCell", bundle: nil)
        teamsCollection.register(teamNib, forCellWithReuseIdentifier: "TeamCell")

        fixturesPresenter = FixturesPresenter(view: self, repository: FixtureRepository(api: FixtureAPI(sportType: sportType ?? .football)))
        teamsPresenter = TeamsPresenter(view: self, repository: TeamRepository(api: TeamAPI(sportType: sportType ?? .football)), sportType: sportType ?? .football)

        setupCollections()
        displayBasicInfo()
        fetchAllData()
        updateTeamsLabel()
        print("player count:\(players.count)")

    }

    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    private func displayBasicInfo() {
        legueName.text = leagueNameText
        CountryName.text = countryNameText

        if let logoURL = leagueLogoURL, let url = URL(string: logoURL) {
            leaguePhoto.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        }
    }

    private func updateTeamsLabel() {
        teamsLabel.text = sportType == .tennis ? "Players" : "Teams"
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.scrolll.contentSize.height = UIDevice.current.orientation.isLandscape ? 2000 : 1000
        })
    }

    private func fetchAllData() {
        guard let leagueId = leagueId else { return }

        fixturesPresenter.fetchUpcomingFixtures(leagueId: leagueId)
        fixturesPresenter.fetchRecentFixtures(leagueId: leagueId)
        teamsPresenter.fetchData(leagueId: leagueId)
    }

    private func setupCollections() {
        [recentCollection, upComingCollection, teamsCollection].forEach {
            $0?.dataSource = self
            $0?.delegate = self
        }
    }
}

// MARK: - FixturesViewProtocol
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

// MARK: - TeamsViewProtocol
extension LeagueDetailsViewController: TeamsViewProtocol {
    func showTennisPlayers(_ players: [TennisPlayer]) {
        self.players = players
        self.teams = []
        DispatchQueue.main.async {
            self.teamsCollection.reloadData()
        }
    }

    func showTeams(_ teams: [Team]) {
        self.teams = teams
        self.players = []
        DispatchQueue.main.async {
            self.teamsCollection.reloadData()
        }
    }
}


// MARK: - UICollectionViewDataSource & Delegate
extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case recentCollection: return recentFixtures.count
        case upComingCollection: return upcomingFixtures.count
        case teamsCollection:
            return sportType == .tennis ? players.count : teams.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == recentCollection || collectionView == upComingCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath) as! FixtureCollectionViewCell
            let fixture = (collectionView == recentCollection ? recentFixtures : upcomingFixtures)[indexPath.row]

            cell.team1Name.text = fixture.eventHomeTeam
            cell.team2Name.text = fixture.eventAwayTeam
            cell.matchDate.text = fixture.eventDate
            cell.matchTime.text = fixture.eventTime
            cell.matchResult.text = collectionView == recentCollection ? (fixture.eventFinalResult ?? "-") : nil

            if let homeLogo = fixture.homeTeamLogo, let url = URL(string: homeLogo) {
                cell.teamImage1.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
            } else {
                cell.teamImage1.image = UIImage(systemName: "photo")
            }

            if let awayLogo = fixture.awayTeamLogo, let url = URL(string: awayLogo) {
                cell.teamImage2.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
            } else {
                cell.teamImage2.image = UIImage(systemName: "photo")
            }

            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamsCollectionViewCell

            if sportType == .tennis {
                let player = players[indexPath.row]
                cell.teamName.text = player.player_name
                if let imgStr = player.player_logo, let url = URL(string: imgStr) {
                    cell.teamImage.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
                } else {
                    cell.teamImage.image = UIImage(systemName: "person.crop.circle")
                }
            } else {
                let team = teams[indexPath.row]
                cell.teamName.text = team.teamName
                if let logoUrlStr = team.teamLogo, let url = URL(string: logoUrlStr) {
                    cell.teamImage.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
                } else {
                    cell.teamImage.image = UIImage(systemName: "photo")
                }
            }

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollection {
            if sportType == .tennis {
                let selectedPlayer = players[indexPath.row]
                print("Selected player: \(selectedPlayer.player_name)")
                
            } else {
                let selectedTeam = teams[indexPath.row]
                print("Selected team: \(selectedTeam.teamName ?? "Unknown")")
                let storyboard = UIStoryboard(name: "TeamDetails", bundle: nil)
                if let navController = storyboard.instantiateViewController(withIdentifier: "navigateToTeamDetails") as? UINavigationController,
                   let teamDetailsVC = navController.viewControllers.first as? TeamDetailsViewController {
                    
                    teamDetailsVC.team = selectedTeam
                    navController.modalPresentationStyle = .fullScreen
                    present(navController, animated: true)
                } else {
                    print("Could not cast to TeamDetailsViewController")
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LeagueDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == teamsCollection {
            return CGSize(width: 150, height: 200)
        } else {
            return CGSize(width: 400, height: 250)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
