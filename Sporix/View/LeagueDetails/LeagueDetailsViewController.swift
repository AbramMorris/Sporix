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
    @IBOutlet weak var scrolll: UIScrollView!

    var leagueId: Int?
    var leagueNameText: String?
    var countryNameText: String?
    var leagueLogoURL: String?
    var sportType: SportType = .football

    private var fixturesPresenter: FixturesPresenter!
    private var teamsPresenter: TeamsPresenter!

    private var recentFixtures: [Fixture] = []
    private var upcomingFixtures: [Fixture] = []
    private var teams: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()

        let fixtureNib = UINib(nibName: "FixtureCollectionViewCell", bundle: nil)
        recentCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")
        upComingCollection.register(fixtureNib, forCellWithReuseIdentifier: "RecentCell")

        let teamNib = UINib(nibName: "TeamsCollectionViewCell", bundle: nil)
        teamsCollection.register(teamNib, forCellWithReuseIdentifier: "TeamCell")

        fixturesPresenter = FixturesPresenter(view: self, repository: FixtureRepository(api: FixtureAPI(sportType: sportType)))
        teamsPresenter = TeamsPresenter(view: self, repository: TeamRepository(api: TeamAPI(sportType: sportType)))

        setupCollections()
        displayBasicInfo()
        fetchAllData()
        showTeams(teams)
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
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.leaguePhoto.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                self.scrolll.contentSize.height = 2000
            } else {
                print("Portrait")
                self.scrolll.contentSize.height = 1000
            }
        })
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
        print("Teams received: \(teams.count)")

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

            loadImage(urlStr: fixture.homeTeamLogo, into: cell.teamImage1)
            loadImage(urlStr: fixture.awayTeamLogo, into: cell.teamImage2)

            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamsCollectionViewCell
            let team = teams[indexPath.row]

            cell.teamName.text = team.teamName
            cell.teamImage.image = nil

            if let logoUrlStr = team.teamLogo, let url = URL(string: logoUrlStr) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.teamImage.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollection {
            let selectedTeam = teams[indexPath.row]
            print("Selected team: \(selectedTeam.teamName ?? "Unknown")")
            // TODO: Navigate to team detail screen or perform another action
            let storyboard = UIStoryboard(name: "TeamDetails", bundle: nil)
            if let teamDeatailsVC = storyboard.instantiateViewController(withIdentifier: "TeamDetails") as? TeamDetailsViewController {
                teamDeatailsVC.team = selectedTeam
                teamDeatailsVC.modalPresentationStyle = .fullScreen
                present(teamDeatailsVC, animated: true)
            } else {
                print("Could not cast to TeamDetailsViewController")
            }
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
