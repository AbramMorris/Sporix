//
//  HomeViewController.swift
//  testProject_Sporix
//
//  Created by abram on 29/05/2025.
//

import UIKit

class SportsViewController: UIViewController {
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var homeCollection: UICollectionView!
    
    let items = ["football", "basketball", "cricket", "tennis"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .dark {
            backImage.image = UIImage(named: "DarckBack")
        } else {
            backImage.image = UIImage(named: "LightBack")
        }
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: "SportsCollectionViewCell", bundle: nil)
        homeCollection.register(nib, forCellWithReuseIdentifier: "HomeCell")

        homeCollection.collectionViewLayout = createSwitcherLayout()
        homeCollection.delegate = self
        homeCollection.dataSource = self
        homeCollection.backgroundColor = .clear

    }

    private func createSwitcherLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(350),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = -180
            section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 60, bottom: 40, trailing: 60)

            section.visibleItemsInvalidationHandler = { items, offset, environment in
                let centerX = offset.x + environment.container.contentSize.width / 2

                for item in items {
                    let distance = abs(item.frame.midX - centerX)
                    let scale = max(0.85, 1 - distance / environment.container.contentSize.width)
                    let translateY = distance / 15

                    item.transform = CGAffineTransform.identity
                        .scaledBy(x: scale, y: scale)
                        .translatedBy(x: 0, y: translateY)

                    item.zIndex = Int(1000 - distance)
                }
            }

            return section
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SportsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? SportsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.homeImage.image = UIImage(named: items[indexPath.item])
        cell.titleHome.text = items[indexPath.item]
        cell.titleHome.textColor = .white
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sport = items[indexPath.item]
        guard let sportType = SportType(rawValue: sport.lowercased()) else {
            print("Invalid sport type: \(sport)")
            return
        }
        
        if NetworkHelper.shared.isNetworkAvailable() {
            let storyboard = UIStoryboard(name: "home", bundle: nil)
            if let nav = storyboard.instantiateViewController(withIdentifier: "LeagueVC") as? UINavigationController,
               let homeVC = nav.viewControllers.first as? HomeViewController {
                homeVC.passedFlag = sportType.rawValue
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true)
            } else {
                print("Could not cast to HomeViewController")
            }
        } else {
            let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
