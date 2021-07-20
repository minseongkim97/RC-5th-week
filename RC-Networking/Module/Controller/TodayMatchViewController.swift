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

let leagueName = ["Premier League", "Primera Division", "Bundesliga", "Serie A", "Ligue 1"]
let leagueWorld = ["🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🇪🇸" ,"🇩🇪", "🇮🇹", "🇫🇷"]


class TodayMatchViewController: UIViewController {
    
    @IBOutlet weak var todayTableView: UITableView! {
        didSet {
            self.todayTableView.dataSource = self
            self.todayTableView.delegate = self
            self.todayTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(todayMatchUrl, method: .get, headers: keyHeader
            ).validate(statusCode: 200..<300).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    for match in json["matches"].arrayValue {
                        if match["competition"]["name"] == "Premier League" {
                            print("round: \(match["matchday"]), home: \(match["homeTeam"]["name"]), away: \(match["awayTeam"]["name"])")
                        }
                    }
                    

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension TodayMatchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        leagueName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        leagueWorld[section] + leagueName[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchTableViewCell
        return cell
    }
    
    
}

extension TodayMatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
