//
//  HomeViewController.swift
//  Sporix
//
//  Created by abram on 31/05/2025.
//
//
//  HomeViewController.swift
//  Sporix
//
//  Created by abram on 31/05/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var leagueCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBackButton()
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        leagueCollectionView.register(nib, forCellWithReuseIdentifier: "leagueCell")
        
        leagueCollectionView.delegate = self
        leagueCollectionView.dataSource = self
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
        let storyboard = UIStoryboard(name: "Sports", bundle: nil)
        if let sportsVC = storyboard.instantiateViewController(withIdentifier: "tab") as? UITabBarController {
            sportsVC.modalPresentationStyle = .fullScreen
            present(sportsVC, animated: false)
        } else {
            print("Could not cast to HomeViewController")
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Replace with actual data source count
        return 10
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 150
        )
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Configure cell with actual data
        // cell.configure(with: league)

        return cell
    }
}
