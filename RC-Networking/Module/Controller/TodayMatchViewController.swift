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
let matchURL = "https://api.football-data.org/v2/matches"

let leagueName = ["Premier League", "Primera Division", "Bundesliga", "Serie A", "Ligue 1"]
let leagueWorld = ["🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🇪🇸" ,"🇩🇪", "🇮🇹", "🇫🇷"]



class TodayMatchViewController: UIViewController {
    
    @IBOutlet weak var todayTableView: UITableView! {
        didSet {
            self.todayTableView.dataSource = self
            self.todayTableView.delegate = self
            self.todayTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchCell")
            self.todayTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    var Match = [[JSON](),[JSON](),[JSON](),[JSON](),[JSON]()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for leagueIndex in 0..<leagueName.count {
            fetchTodayData(leagueIndex: leagueIndex)
        }
        
       
    }
    
    
    func fetchTodayData(leagueIndex: Int) {

        AF.request(matchURL, method: .get, headers: keyHeader
        ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                for match in json["matches"].arrayValue {
                    if match["competition"]["name"] == JSON(leagueName[leagueIndex]) {
                        self.Match[leagueIndex].append(match)
                    }
                }
             
                self.todayTableView.reloadData()
                
              

            case .failure(let error):
                print(error)
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
        if Match[section].count == 0 {
            return 1
        } else {
            return Match[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchTableViewCell

        if Match[indexPath.section].count == 0 {
            cell.timeLabel.text = ""
            cell.teamLabel.text = "일정이 없습니다"
            cell.leaguePlaceLabel.text = ""
        } else {
            cell.timeLabel.text = "\(Match[indexPath.section][indexPath.row]["utcDate"].stringValue[String.Index(encodedOffset: 11)...String.Index(encodedOffset: 15)])"
            cell.teamLabel.text = "\(Match[indexPath.section][indexPath.row]["homeTeam"]["name"]) vs \(Match[indexPath.section][indexPath.row]["awayTeam"]["name"])"
            cell.leaguePlaceLabel.text = "\(leagueName[indexPath.section]) \(Match[indexPath.section][indexPath.row]["matchday"])R"
        }
        return cell
    }
    
    
}

extension TodayMatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
