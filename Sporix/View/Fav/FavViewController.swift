//
//  FavViewController.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesViewProtocol   {
    
    var favItems: [Fav] = []
    var presenter: FavoritesPresenter!

 
    @IBOutlet weak var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "FavTableViewCell", bundle: nil)
        favTableView.register(nib, forCellReuseIdentifier: "cell")
        
        presenter = FavoritesPresenter(view: self)
        presenter.loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func showFavorites(_ favorites: [Fav]) {
        self.favItems = favorites
        self.favTableView.reloadData()
     }
     
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        cell.titleLabel.text = item.LeagueName
        
        if let url = URL(string: item.LeagueImage ?? "") {
            cell.imageViewCell.kf.setImage(with: url, placeholder: UIImage(named: "images"))
        } else {
            cell.imageViewCell.image = UIImage(named: "images")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fav = favItems[indexPath.row]
        print("Item name >> \(fav.LeagueName)")

//        let storyboard = UIStoryboard(name: "Details", bundle: nil)
//        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
//            detailsVC.fav = fav
//            navigationController?.pushViewController(detailsVC, animated: true)
//        }
    }
    
    
}
