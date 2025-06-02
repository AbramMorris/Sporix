//
//  FavViewController.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
 
    var favItems: [Fav] = [
         Fav(id: 1, name: "Premier League", image: "https://upload.wikimedia.org/wikipedia/en/f/f2/Premier_League_Logo.svg"),
         Fav(id: 2, name: "La Liga", image: "https://upload.wikimedia.org/wikipedia/en/7/79/LaLiga_Santander.svg"),
         Fav(id: 3, name: "Serie A", image: "https://upload.wikimedia.org/wikipedia/en/e/e1/Serie_A_logo_%282019%29.svg")
     ]
    
    @IBOutlet weak var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "FavTableViewCell", bundle: nil)
        favTableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return favItems.count
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FavTableViewCell else {
                  return UITableViewCell()
              }

        let item = favItems[indexPath.row]
        cell.titleLabel.text = item.name
        
        if let url = URL(string: item.image ?? "") {
            cell.imageViewCell.kf.setImage(with: url, placeholder: UIImage(named: "images"))
        } else {
            cell.imageViewCell.image = UIImage(named: "images")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fav = favItems[indexPath.row]
        print("Item name >> \(fav.name)")

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
//            detailsVC.fav = fav
//            navigationController?.pushViewController(detailsVC, animated: true)
//        }
    }

   
}
