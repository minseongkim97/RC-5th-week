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
let searchKeyHeader: HTTPHeaders = ["X-Naver-Client-Id":"7qvSWUXGr4u4_LWGUeZK", "X-Naver-Client-Secret":"Uk_iPt0WuN"]
let matchURL = "https://api.football-data.org/v2/matches"
let teamURL = "https://api.football-data.org/v2/competitions/PD/teams"
let searchURL = "https://openapi.naver.com/v1/search/news.json"

let leagueName = ["Premier League", "Primera Division", "Bundesliga", "Serie A", "Ligue 1"]
let leagueSymbol = ["PL", "PD", "BL1", "SA", "FL1"]
let leagueWorld = ["🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🇪🇸" ,"🇩🇪", "🇮🇹", "🇫🇷"]
//var Team = ["Manchester City FC", "Arsenal FC", "Aston Villa FC", "Brentford FC", "Brighton & Hove Albion FC", "Burnley FC", "Chelsea FC", "Crystal Palace FC", "Everton FC", "Fulham FC", "Leeds United FC", "Leicester City FC", "Liverpool FC", "Manchester United FC", "Newcastle United FC", "Norwich City FC", "Sheffield United FC", "Southampton FC", "Tottenham Hotspur FC", "Watford FC", "West Bromwich Albion FC", "West Ham United FC", "Wolverhampton Wanderers FC"]
var FTeam = [FootballTeam]()


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
        fetchTodayData()
        for leagueIndex in 0..<leagueName.count {
            
            fetchTeamData(leagueIndex: leagueIndex)
            
        }
        
       
    }
    
    
    func fetchTodayData() {
        FTeam = []
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: Date()))
        AF.request(matchURL, method: .get, parameters: ["dateFrom":formatter.string(from: Date()), "dateTo":formatter.string(from: Date())], headers: keyHeader
        ).validate(statusCode: 200..<300)
//        .responseDecodable(of: <#T##Decodable.Protocol#>, queue: <#T##DispatchQueue#>, dataPreprocessor: <#T##DataPreprocessor#>, decoder: <#T##DataDecoder#>, emptyResponseCodes: <#T##Set<Int>#>, emptyRequestMethods: <#T##Set<HTTPMethod>#>, completionHandler: <#T##(DataResponse<Decodable, AFError>) -> Void#>)
        .responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                for match in json["matches"].arrayValue {
                    for leagueIndex in 0..<leagueName.count {
                        if match["competition"]["name"] == JSON(leagueName[leagueIndex]) {
                            self.Match[leagueIndex].append(match)
                        }
                    }

                }
                DispatchQueue.main.async {
                    self.todayTableView.reloadData()
                }


            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTeamData(leagueIndex: Int) {

        AF.request("https://api.football-data.org/v2/competitions/\(leagueSymbol[leagueIndex])/teams", method: .get, headers: keyHeader
        ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                
                for match in json["teams"].arrayValue {
                    let team = FootballTeam(imageUrl: match["crestUrl"].stringValue, name: match["name"].stringValue, id: match["id"].intValue)
                    FTeam.append(team)
                }
                print(FTeam)
                
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
            cell.timeLabel.text = "\(Match[indexPath.section][indexPath.row]["utcDate"].stringValue[String.Index(utf16Offset: 11, in: Match[indexPath.section][indexPath.row]["utcDate"].stringValue)...String.Index(utf16Offset: 15, in: Match[indexPath.section][indexPath.row]["utcDate"].stringValue)])"
            cell.teamLabel.text = "\(Match[indexPath.section][indexPath.row]["homeTeam"]["name"])   vs   \(Match[indexPath.section][indexPath.row]["awayTeam"]["name"])"
            cell.leaguePlaceLabel.text = "\(leagueName[indexPath.section]) \(Match[indexPath.section][indexPath.row]["matchday"])R"
        }
        return cell
    }
    
    
}

extension TodayMatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
    }
}
