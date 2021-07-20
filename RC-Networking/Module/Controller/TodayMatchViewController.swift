//
//  TodayMatchViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/20.
//

import UIKit
import Alamofire
import SwiftyJSON

let keyHeader: HTTPHeaders = ["X-Auth-Token":"0c7ba7745c1948c5b38389c2bb730ad9"]
let todayMatchUrl = "https://api.football-data.org/v2/matches"

class TodayMatchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request(todayMatchUrl, method: .get, headers: keyHeader
        ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                for match in json["matches"].arrayValue {
                    if match["competition"]["name"] == "UEFA Champions League" {
                        print("round: \(match["matchday"]), home: \(match["homeTeam"]["name"]), away: \(match["awayTeam"]["name"])")
                    }
                }
                print(json["matches"][0]["competition"]["name"])

            case .failure(let error):
                print(error)
            }
        }
    }
}
