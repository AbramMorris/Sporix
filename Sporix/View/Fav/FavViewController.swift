//
//  FavViewController.swift
//  Sporix
//
//  Created by User on 01/06/2025.
//

import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesViewProtocol   {
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var favTableView: UITableView!
    
    var emptyLabel: UILabel = {
          let label = UILabel()
          label.text = "No favorites found"
          label.textAlignment = .center
          label.textColor = .gray
          label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
          label.numberOfLines = 0
          label.isHidden = true
          return label
      }()
    
    var favItems: [Fav] = []
    var allItems: [Fav] = []
    var presenter: FavoritesPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.delegate = self
        favTableView.dataSource = self
        segmentedControl.selectedSegmentIndex = 0
        favTableView.separatorStyle = .none
        favTableView.backgroundColor = .clear
        let nib = UINib(nibName: "FavTableViewCell", bundle: nil)
        favTableView.register(nib, forCellReuseIdentifier: "cell")
        
        view.addSubview(emptyLabel)
         emptyLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
             emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
         ])
        
        presenter = FavoritesPresenter(view: self)
        presenter.loadFavorites()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .dark {
            backImage.image = UIImage(named: "DarckBack")
        } else {
            backImage.image = UIImage(named: "LightBack")
        }
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

        if NetworkHelper.shared.isNetworkAvailable() {
            let storyboard = UIStoryboard(name: "LeagueDetails", bundle: nil)
            guard let navController = storyboard.instantiateViewController(withIdentifier: "LeagueDetails") as? UINavigationController,
                  let leagueDetailsVC = navController.viewControllers.first as? LeagueDetailsViewController else {
                print("Could not instantiate LeagueDetailsViewController")
                return
            }
            leagueDetailsVC.leagueId = fav.id
            leagueDetailsVC.leagueNameText = fav.LeagueName
            leagueDetailsVC.countryNameText = fav.countryName
            leagueDetailsVC.leagueLogoURL = fav.LeagueImage
            leagueDetailsVC.sportType = SportType(rawValue: fav.sportType ) ?? .football
            
            if let nav = navigationController {
                nav.pushViewController(navController, animated: true)
            } else {
                print("navigationController is nil, presenting modally")
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true)
            }
            
        } else {
            let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
        
        let isEmpty = favItems.isEmpty
        favTableView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
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
                self.presenter.deleteFavorite(item.id)
            })

            self.present(alert, animated: true)
            completionHandler(false)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
