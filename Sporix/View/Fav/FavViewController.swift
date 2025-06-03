//
//  FavViewController.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesViewProtocol   {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var favTableView: UITableView!
    
    var favItems: [Fav] = []
    var allItems: [Fav] = []
    var presenter: FavoritesPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.delegate = self
        favTableView.dataSource = self
        segmentedControl.selectedSegmentIndex = 0
        favTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "FavTableViewCell", bundle: nil)
        favTableView.register(nib, forCellReuseIdentifier: "cell")
        
        presenter = FavoritesPresenter(view: self)
        presenter.loadFavorites()
    }
    
    func showFavorites(_ favorites: [Fav]) {
        self.allItems = favorites
        applyFilter()
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

    @IBAction func filterSegment(_ sender: Any) {
        applyFilter()
    }
    
    func applyFilter() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            favItems = allItems
        case 1:
            favItems = allItems.filter { $0.sportType == SportType.football.rawValue }
        case 2:
            favItems = allItems.filter { $0.sportType == SportType.basketball.rawValue }
        case 3:
            favItems = allItems.filter { $0.sportType == SportType.cricket.rawValue }
        case 4:
            favItems = allItems.filter { $0.sportType == SportType.tennis.rawValue }
        default:
            favItems = allItems
        }
        favTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let item = self.favItems[indexPath.row]

            let alert = UIAlertController(
                title: "Remove Favorite",
                message: "Are you sure you want to remove '\(item.LeagueName)' from favorites?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.presenter.deleteFavorite(by: item.id)
            })

            self.present(alert, animated: true)
            completionHandler(false)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
