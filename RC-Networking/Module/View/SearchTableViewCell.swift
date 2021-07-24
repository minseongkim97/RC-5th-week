//
//  SearchTableViewCell.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
