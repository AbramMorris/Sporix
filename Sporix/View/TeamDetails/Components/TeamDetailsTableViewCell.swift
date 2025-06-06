//
//  TeamDetailsTableViewCell.swift
//  Sporix
//
//  Created by User on 04/06/2025.
//

import UIKit

class TeamDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
