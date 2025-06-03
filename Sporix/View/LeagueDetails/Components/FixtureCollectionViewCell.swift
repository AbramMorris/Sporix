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
        // Initialization code
    }

}
