//
//  LeagueTableViewCell.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueCountry: UILabel!
    @IBOutlet weak var leagueTitle: UILabel!
    
    weak var delegate: FavoriteDelegate?
    var league: League?
    
    var isFavorite = false {
       didSet {
           updateFavoriteIcon()
       }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateBackground(for: traitCollection)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        updateBackground(for: traitCollection)
    }
    
    private func updateFavoriteIcon() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)?
            .withTintColor(isFavorite ? .red : .white, renderingMode: .alwaysOriginal)
        favButton.setImage(image, for: .normal)
    }

    @IBAction func addFav(_ sender: Any) {
        guard let league = league else { return }
        if isFavorite {
            print("league removed >>>>")
            delegate?.didRemoveFromFavorites(league)
        } else {
            print("league added >>>>")
            delegate?.didAddToFavorites(league)
        }
        isFavorite.toggle()
    }
   

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBackground(for: traitCollection)
            setNeedsLayout()
        }
    }

    private func updateBackground(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            viewContent.backgroundColor = .white
            favButton.setBackgroundImage(nil, for: .normal)
            favButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

            leagueCountry.textColor = .black
            leagueTitle.textColor = .black
        } else {
            viewContent.backgroundColor =  UIColor(red: 162/255, green: 192/255, blue: 200/255, alpha: 1) 
            leagueCountry.textColor = .label
            leagueTitle.textColor = .label
            favButton.backgroundColor = UIColor(red: 162/255, green: 192/255, blue: 200/255, alpha: 1)
        }
    }
}
