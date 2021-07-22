//
//  ImageMatchTableViewCell.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/21.
//

import UIKit

class ImageMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var awayTeamLabel: UILabel! {
        didSet {
            self.awayTeamLabel.adjustsFontSizeToFitWidth = true
            self.awayTeamLabel.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var homeTeamLabel: UILabel! {
        didSet {
            self.homeTeamLabel.adjustsFontSizeToFitWidth = true
            self.homeTeamLabel.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
