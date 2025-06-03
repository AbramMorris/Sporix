//
//  LeagueTableViewCell.swift
//  Sporix
//
//  Created by abram on 02/06/2025.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leagueCountry: UILabel!
    @IBOutlet weak var leagueTitle: UILabel!
    
    weak var delegate: FavoriteDelegate?
    var league: League?
    
    var isFavorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    

    @IBAction func addFav(_ sender: Any) {
        print("tapped on fav >>>")

        guard let league = league else { return }

        print("tapped on fav >>>")
        
        if isFavorite {
            print("league removed >>>>")
            delegate?.didRemoveFromFavorites(league)
        } else {
            print("league added >>>>")
            delegate?.didAddToFavorites(league)
        }
        isFavorite.toggle()
    }
    
}
