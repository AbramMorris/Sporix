//
//  LeagueDetailsViewController.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import UIKit
import Kingfisher

class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
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
        
        let fixtureNib = UINib(nibName: "FixtureCollectionViewCell", bundle: nil)
        recentCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")
        upComingCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")

        let teamNib = UINib(nibName: "TeamsCollectionViewCell", bundle: nil)
        teamsCollection.register(teamNib, forCellWithReuseIdentifier: "TeamCell")

        fixturesPresenter = FixturesPresenter(view: self,
                                              repository: FixtureRepository(api: FixtureAPI(sportType: sportType ?? .football)))
        teamsPresenter = TeamsPresenter(view: self,
                                        repository: TeamRepository(api: TeamAPI(sportType: sportType ?? .football)),
                                        sportType: sportType ?? .football)

        [recentCollection, upComingCollection, teamsCollection].forEach {
            $0?.dataSource = self
            $0?.delegate = self
            $0?.backgroundColor = .clear
        }

        displayBasicInfo()
        updateTeamsLabel()
        fetchAllData()
        updateBackground(for: traitCollection)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBackground(for: traitCollection)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBackground(for: traitCollection)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.scrolll.contentSize.height = UIDevice.current.orientation.isLandscape ? 2000 : 1000
        })
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    private func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonTapped))
    }

    private func updateBackground(for traitCollection: UITraitCollection) {
        backImage.image = UIImage(named: traitCollection.userInterfaceStyle == .dark ? "DarkStade" : "lightStade")
    }

    private func displayBasicInfo() {
        legueName.text = leagueNameText
        CountryName.text = countryNameText
        if let urlString = leagueLogoURL, let url = URL(string: urlString) {
            leaguePhoto.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        }
    }

    private func updateTeamsLabel() {
        teamsLabel.text = sportType == .tennis ? "Players" : "Teams"
    }

    private func fetchAllData() {
        guard let id = leagueId else { return }
        fixturesPresenter.fetchUpcomingFixtures(leagueId: id)
        fixturesPresenter.fetchRecentFixtures(leagueId: id)
        teamsPresenter.fetchData(leagueId: id)
    }
}


extension LeagueDetailsViewController: FixturesViewProtocol {
    func showUpcomingFixtures(_ fixtures: [Fixture]) {
        upcomingFixtures = fixtures
        upComingCollection.reloadData()
    }

    func showRecentFixtures(_ fixtures: [Fixture]) {
        recentFixtures = fixtures
        recentCollection.reloadData()
    }

    func showError(_ message: String) {
        print("Fixtures error: \(message)")
    }
}

extension LeagueDetailsViewController: TeamsViewProtocol {
    func showTeams(_ teams: [Team]) {
        self.teams = teams
        self.players = []
        teamsCollection.reloadData()
    }

    func showTennisPlayers(_ players: [TennisPlayer]) {
        self.players = players
        self.teams = []
        teamsCollection.reloadData()
    }
}


extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cv == recentCollection {
            return max(recentFixtures.count, 1)
        } else if cv == upComingCollection {
            return max(upcomingFixtures.count, 1)
        } else {
            let count = sportType == .tennis ? players.count : teams.count
            return max(count, 1)
        }
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cv == recentCollection || cv == upComingCollection {
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath) as! FixtureCollectionViewCell
            let fixtures = cv == recentCollection ? recentFixtures : upcomingFixtures

            if fixtures.isEmpty {
                hideFixtureContent(in: cell)
                showNoData(in: cell)
            } else {
                removeNoData(from: cell)
                showFixtureContent(in: cell)

                let f = fixtures[indexPath.row]
                cell.team1Name.text = f.eventHomeTeam
                cell.team2Name.text = f.eventAwayTeam
                cell.matchDate.text = f.eventDate
                cell.matchTime.text = f.eventTime
                cell.matchResult.text = f.eventFinalResult
                cell.matchResult.isHidden = (cv == upComingCollection)

                if let hUrl = f.homeTeamLogo, let url = URL(string: hUrl) {
                    cell.teamImage1.kf.setImage(with: url)
                }
                if let aUrl = f.awayTeamLogo, let url = URL(string: aUrl) {
                    cell.teamImage2.kf.setImage(with: url)
                }
            }
            return cell

        } else {
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamsCollectionViewCell
            let noData = (sportType == .tennis ? players.isEmpty : teams.isEmpty)

            if noData {
                hideTeamContent(in: cell)
                showNoData(in: cell)
            } else {
                removeNoData(from: cell)
                showTeamContent(in: cell)

                if sportType == .tennis {
                    let player = players[indexPath.row]
                    cell.teamName.text = player.player_name
                    if let urlStr = player.player_logo, let url = URL(string: urlStr) {
                        cell.teamImage.kf.setImage(with: url)
                    }
                } else {
                    let team = teams[indexPath.row]
                    cell.teamName.text = team.teamName
                    if let urlStr = team.teamLogo, let url = URL(string: urlStr) {
                        cell.teamImage.kf.setImage(with: url)
                    }
                }
            }
            return cell
        }
    }

    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard cv == teamsCollection else { return }
        guard !(sportType == .tennis ? players.isEmpty : teams.isEmpty) else { return }

        if sportType == .tennis {
            print("Selected player: \(players[indexPath.row].player_name)")
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "navigateToTeamDetails") as? UINavigationController,
               let teamDetails = vc.viewControllers.first as? TeamDetailsViewController {
                teamDetails.team = teams[indexPath.row]
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        }
    }

    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cv == teamsCollection ? CGSize(width: 150, height: 200)
                                     : CGSize(width: 400, height: 250)
    }

    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }

    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
}


private extension LeagueDetailsViewController {
    func showNoData(in cell: UICollectionViewCell) {
        removeNoData(from: cell)
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "noData")
        iv.contentMode = .scaleAspectFit
        iv.tag = 999
        cell.contentView.addSubview(iv)
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
        ])
    }

    func removeNoData(from cell: UICollectionViewCell) {
        cell.contentView.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }
    }

    func hideFixtureContent(in c: FixtureCollectionViewCell) {
        [c.team1Name, c.team2Name, c.matchDate,
         c.matchTime, c.matchResult,
         c.teamImage1, c.teamImage2,c.vsPic].forEach { $0?.isHidden = true }
    }

    func showFixtureContent(in c: FixtureCollectionViewCell) {
        [c.team1Name, c.team2Name, c.matchDate,
         c.matchTime, c.matchResult,
         c.teamImage1, c.teamImage2,c.vsPic].forEach { $0?.isHidden = false }
    }

    func hideTeamContent(in c: TeamsCollectionViewCell) {
        [c.teamName, c.teamImage].forEach { $0?.isHidden = true }
    }

    func showTeamContent(in c: TeamsCollectionViewCell) {
        [c.teamName, c.teamImage].forEach { $0?.isHidden = false }
    }
}
