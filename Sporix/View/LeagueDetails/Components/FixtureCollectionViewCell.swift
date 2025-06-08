//
//  FixtureCollectionViewCell.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import UIKit

class FixtureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var teamImage1: UIImageView!
    
    @IBOutlet weak var matchResult: UILabel!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var teamImage2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        updateBackground(for: traitCollection)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBackground(for: traitCollection)
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
            self.backgroundColor = .white
            matchTime.textColor = .black
            matchDate.textColor = .black
            matchResult.textColor = .black
            team2Name.textColor = .black
            team1Name.textColor = .black
        } else {
            self.backgroundColor =  UIColor(red: 162/255, green: 192/255, blue: 200/255, alpha: 1) // #a2c0c8
            matchTime.textColor = .label
            matchDate.textColor = .label
            matchResult.textColor = .label
            team2Name.textColor = .label
            team1Name.textColor = .label
        }
    }
}
