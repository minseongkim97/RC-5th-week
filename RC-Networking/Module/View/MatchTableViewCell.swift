//
//  MatchTableViewCell.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/20.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var leaguePlaceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        teamLabel.adjustsFontSizeToFitWidth = true
        teamLabel.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
