//
//  LeagueCollectionViewCell.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/20.
//

import UIKit

class LeagueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leagueImage: UIImageView! {
        didSet {
            self.leagueImage.layer.cornerRadius = 8
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
