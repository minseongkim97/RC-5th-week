//
//  Team.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/23.
//

import UIKit

struct FootballTeam {
    let imageUrl: String
    let name: String
    let id: Int

}

extension FootballTeam: Equatable { static func ==(lhs: FootballTeam, rhs: FootballTeam) -> Bool { return (lhs.name == rhs.name) && (lhs.id == rhs.id) }
}
