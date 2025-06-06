//
//  TeamDetailsViewController.swift
//  Sporix
//
//  Created by User on 04/06/2025.
//

import UIKit
import Kingfisher



class TeamDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var teamTableView: UITableView!

    var team: Team?

    var teamData: [[TeamMember]] = []
    var sectionTitles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        teamTableView.delegate = self
        teamTableView.dataSource = self
        teamTableView.separatorStyle = .none

        let nib = UINib(nibName: "TeamDetailsTableViewCell", bundle: nil)
        teamTableView.register(nib, forCellReuseIdentifier: "teamCell")

        configureTeamDetails()
    }
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    private func configureTeamDetails() {
        guard let team = team else { return }

        clubLabel.text = team.teamName
        if let logo = team.teamLogo, let url = URL(string: logo) {
            clubImage.kf.setImage(with: url)
        } else {
            clubImage.image = UIImage(systemName: "photo")
        }

        var coaches: [TeamMember] = []
        var defenders: [TeamMember] = []
        var midfielders: [TeamMember] = []
        var forwards: [TeamMember] = []
        var goalkeepers: [TeamMember] = []
        var others: [TeamMember] = []

        
        if let teamCoaches = team.coaches {
            for coach in teamCoaches {
                coaches.append(
                    TeamMember(
                        name: coach.coachName,
                        imageURL: "",
                        position: "Coach",
                        jerseyNumber: "-",
                        nationality: coach.coachCountry ?? "-"
                    )
                )
            }
        }

        
        if let teamPlayers = team.players {
            for player in teamPlayers {
                let type = player.playerType?.lowercased() ?? "-"
                let member = TeamMember(
                    name: player.playerName,
                    imageURL: player.playerImage ?? "",
                    position: type.capitalized,
                    jerseyNumber: player.playerNumber ?? "-",
                    nationality: player.playerCountry ?? "-"
                )
                print(player.playerCountry ?? "default value")

                switch type {
                case "defender": defenders.append(member)
                case "midfielder": midfielders.append(member)
                case "forward": forwards.append(member)
                case "goalkeeper": goalkeepers.append(member)
                default: others.append(member)
                }
            }
        }

        teamData = []
        sectionTitles = []

        if !coaches.isEmpty {
            teamData.append(coaches)
            sectionTitles.append("Coaches")
        }
        if !goalkeepers.isEmpty {
            teamData.append(goalkeepers)
            sectionTitles.append("Goalkeepers")
        }
        if !defenders.isEmpty {
            teamData.append(defenders)
            sectionTitles.append("Defenders")
        }
        if !midfielders.isEmpty {
            teamData.append(midfielders)
            sectionTitles.append("Midfielders")
        }
        if !forwards.isEmpty {
            teamData.append(forwards)
            sectionTitles.append("Forwards")
        }
        if !others.isEmpty {
            teamData.append(others)
            sectionTitles.append("Others")
        }

        teamTableView.reloadData()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return teamData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamData[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamDetailsTableViewCell else {
            return UITableViewCell()
        }

        let member = teamData[indexPath.section][indexPath.row]
        cell.nameLabel.text = member.name
        if let url = URL(string: member.imageURL) {
            cell.playerImage.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill"))
        } else {
            cell.playerImage.image = UIImage(systemName: "person.fill")
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = teamData[indexPath.section][indexPath.row]

        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: """
        Name: \(member.name)
        Position: \(member.position)
        Jersey Number: \(member.jerseyNumber)
        """, preferredStyle: .alert)

        let imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 230, height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .white

        if let url = URL(string: member.imageURL) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill"))
        }

        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
