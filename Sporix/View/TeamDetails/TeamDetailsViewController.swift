//
//  TeamDetailsViewController.swift
//  Sporix
//
//  Created by User on 04/06/2025.
//

import UIKit
import Kingfisher

struct TeamMember {
    let name: String
    let imageName: String
    let position: String
    let jerseyNumber: Int
    let nationality: String
}

class TeamDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clubImage: UIImageView!
    
    @IBOutlet weak var clubLabel: UILabel!
    
    @IBOutlet weak var teamTableView: UITableView!
    
    let sections = ["Coach", "Defenders", "Midfielders", "Forwards"]

    let teamData: [[TeamMember]] = [
        [TeamMember(name: "Pep Guardiola", imageName: "https://upload.wikimedia.org/wikipedia/commons/4/4e/Pep_Guardiola_2017.jpg", position: "Coach", jerseyNumber: 0, nationality: "Spain")],
        [
            TeamMember(name: "Kyle Walker", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p80407.png", position: "Defender", jerseyNumber: 2, nationality: "England"),
            TeamMember(name: "Rúben Dias", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p171314.png", position: "Defender", jerseyNumber: 3, nationality: "Portugal"),
            TeamMember(name: "John Stones", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p97299.png", position: "Defender", jerseyNumber: 5, nationality: "England"),
            TeamMember(name: "Joško Gvardiol", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p500948.png", position: "Defender", jerseyNumber: 24, nationality: "Croatia")
        ],
        [
            TeamMember(name: "Kevin De Bruyne", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p61366.png", position: "Midfielder", jerseyNumber: 17, nationality: "Belgium"),
            TeamMember(name: "Rodri", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p220566.png", position: "Midfielder", jerseyNumber: 16, nationality: "Spain"),
            TeamMember(name: "Bernardo Silva", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p165153.png", position: "Midfielder", jerseyNumber: 20, nationality: "Portugal")
        ],
        [
            TeamMember(name: "Erling Haaland", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p223094.png", position: "Forward", jerseyNumber: 9, nationality: "Norway"),
            TeamMember(name: "Phil Foden", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p199798.png", position: "Forward", jerseyNumber: 47, nationality: "England"),
            TeamMember(name: "Jack Grealish", imageName: "https://resources.premierleague.com/premierleague/photos/players/250x250/p103955.png", position: "Forward", jerseyNumber: 10, nationality: "England")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clubLabel.text = "Manchester City"
        clubImage.image = UIImage(named: "images")
              
        teamTableView.delegate = self
        teamTableView.dataSource = self
        teamTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "TeamDetailsTableViewCell", bundle: nil)
        teamTableView.register(nib, forCellReuseIdentifier: "teamCell")
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamData[section].count
    }
     
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamDetailsTableViewCell else {
             return UITableViewCell()
         }
         
         let member = teamData[indexPath.section][indexPath.row]
         cell.nameLabel.text = member.name
         cell.playerImage.kf.setImage(with: URL(string: member.imageName), placeholder: UIImage(systemName: "person.fill"))
         
         return cell
     }
     
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = teamData[indexPath.section][indexPath.row]

        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: """
        Name: \(member.name)
        Position: \(member.position)
        Jersey Number: \(member.jerseyNumber)
        Nationality: \(member.nationality)
        """, preferredStyle: .alert)

        let imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 230, height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .white

        if let url = URL(string: member.imageName) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill"))
        }

        alert.view.addSubview(imageView)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
