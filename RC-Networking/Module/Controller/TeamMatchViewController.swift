//
//  TeamMatchViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/24.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class TeamMatchViewController: UIViewController {

    var teamID: Int = 0
    var teamMatch = [JSON]()
    
    @IBOutlet weak var teamMatchTableView: UITableView!  {
        didSet {
            self.teamMatchTableView.dataSource = self
            self.teamMatchTableView.delegate = self
            self.teamMatchTableView.register(UINib(nibName: "ImageMatchTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageMatchCell")
            self.teamMatchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTeamMatchData(teamId: teamID)
    }
    
    func fetchTeamMatchData(teamId: Int) {
        print(teamId)
        teamMatch = []
        let teamMatchUrl = "https://api.football-data.org/v2/teams/\(teamId)/matches?status=SCHEDULED"
        AF.request(teamMatchUrl, method: .get, headers: keyHeader
        ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                self.teamMatch = json["matches"].arrayValue
                DispatchQueue.main.async {
                    self.teamMatchTableView.reloadData()
                }
              
                
              

            case .failure(let error):
                print(error)
            }
        }
    }

}

extension TeamMatchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teamMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMatchCell", for: indexPath) as! ImageMatchTableViewCell
        
        cell.timeLabel.text = "\(teamMatch[indexPath.row]["utcDate"].stringValue[String.Index(utf16Offset: 11, in: teamMatch[indexPath.row]["utcDate"].stringValue)...String.Index(utf16Offset: 15, in: teamMatch[indexPath.row]["utcDate"].stringValue)])"
        cell.homeTeamLabel.text = "\(teamMatch[indexPath.row]["homeTeam"]["name"])"
        cell.awayTeamLabel.text = "\(teamMatch[indexPath.row]["awayTeam"]["name"])"
        cell.roundLabel.text = "\(teamMatch[indexPath.row]["matchday"])R"
        cell.homeTeamScoreLabel.text = "0"
        cell.awayTeamScoreLabel.text = "0"
        cell.homeTeamImage.image = UIImage(named: "\(teamMatch[indexPath.row]["homeTeam"]["name"])")
        cell.awayTeamImage.image = UIImage(named: "\(teamMatch[indexPath.row]["awayTeam"]["name"])")
        
        return cell
    }
    
    
}

extension TeamMatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
