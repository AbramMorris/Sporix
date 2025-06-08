//
//  TeamsCollectionViewCell.swift
//  Sporix
//
//  Created by abram on 03/06/2025.
//

import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
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
            teamName.textColor = .black

        } else {
            self.backgroundColor =  UIColor(red: 162/255, green: 192/255, blue: 200/255, alpha: 1) // #a2c0c8
            teamName.textColor = .label
        }
    }
}
