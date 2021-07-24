//
//  EachLeagueViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import FSCalendar
import Kingfisher

class EachLeagueViewController: UIViewController {

    var team: String = ""
    var leagueIndex: Int = 0
    var leagueColorNumber: Int = 0
    var leagueColor: UIColor = .black
    var formatter = DateFormatter()
    var eachLeagueMatch = [JSON]()
    
    @IBOutlet weak var calendar: FSCalendar! {
        didSet {
            self.calendar.delegate = self
            self.calendar.dataSource = self
            self.calendar.backgroundColor = .clear
            self.calendar.locale = Locale(identifier: "ko_KR")
            
        }
    }
    
    @IBOutlet weak var matchTableView: UITableView! {
        didSet {
            self.matchTableView.dataSource = self
            self.matchTableView.delegate = self
            self.matchTableView.register(UINib(nibName: "ImageMatchTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageMatchCell")
            self.matchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var league: UILabel!
    @IBOutlet weak var leagueColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: Date()))
        

        fetchEachLeagueData(leagueIndex: leagueIndex, date: formatter.string(from: Date()))
        
        league.text = team
        switch leagueColorNumber {
        case 0:
            leagueColor = #colorLiteral(red: 0.3928713799, green: 0.1675376892, blue: 0.4039141536, alpha: 1)
        case 1:
            leagueColor = #colorLiteral(red: 0.918402493, green: 0.6812929511, blue: 0.8730511665, alpha: 1)
        case 2:
            leagueColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case 3:
            leagueColor = #colorLiteral(red: 0.05646399409, green: 0.3465620279, blue: 0.6855763197, alpha: 1)
        case 4:
            leagueColor = #colorLiteral(red: 0.8713768125, green: 0.8665499091, blue: 0.1480024755, alpha: 1)
        default:
            leagueColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        leagueColorView.backgroundColor = leagueColor
        
        calendar.scope = .week
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 17.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.todayColor = .red
        calendar.appearance.selectionColor = leagueColor
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func calenderBtnPressed(_ sender: UIButton) {
        
        if calendar.scope == .week {
            calendar.backgroundColor = .systemGroupedBackground
            calendar.scope = .month
        } else {
            calendar.backgroundColor = .clear
            calendar.scope = .week
        }
    }
    
    func fetchEachLeagueData(leagueIndex: Int, date: String) {
        self.eachLeagueMatch = []
        AF.request(matchURL, method: .get, parameters: ["competitions":leagueSymbol[leagueIndex], "dateFrom":date, "dateTo":date], headers: keyHeader
        ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                for match in json["matches"].arrayValue {
                    if match["competition"]["name"] == JSON(leagueName[leagueIndex]) {
                        self.eachLeagueMatch.append(match)
                    }
                }
                DispatchQueue.main.async {
                    self.matchTableView.reloadData()
                }
              
                
              

            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension EachLeagueViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
    }
    
}

extension EachLeagueViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: date))
        

        fetchEachLeagueData(leagueIndex: leagueIndex, date: formatter.string(from: date))
        
      
        
        if calendar.scope == .month {
            calendar.backgroundColor = .clear
            calendar.scope = .week
        }
    }
}

extension EachLeagueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eachLeagueMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMatchCell", for: indexPath) as! ImageMatchTableViewCell
        
        if eachLeagueMatch[indexPath.row]["status"] == "SCHEDULED" {
            cell.statusLabel.text = "예정"
        } else {
            cell.statusLabel.backgroundColor = .red
            cell.statusLabel.textColor = .white
            cell.statusLabel.text = "종료"
        }
        cell.timeLabel.text = "\(eachLeagueMatch[indexPath.row]["utcDate"].stringValue[String.Index(utf16Offset: 11, in: eachLeagueMatch[indexPath.row]["utcDate"].stringValue)...String.Index(utf16Offset: 15, in: eachLeagueMatch[indexPath.row]["utcDate"].stringValue)])"
        cell.homeTeamLabel.text = "\(eachLeagueMatch[indexPath.row]["homeTeam"]["name"])"
        cell.awayTeamLabel.text = "\(eachLeagueMatch[indexPath.row]["awayTeam"]["name"])"
        cell.roundLabel.text = "\(eachLeagueMatch[indexPath.row]["matchday"])R"
        
        if "\(eachLeagueMatch[indexPath.row]["score"]["fullTime"]["homeTeam"])" == "null" {
            cell.homeTeamScoreLabel.text = "0"
        } else {
            cell.homeTeamScoreLabel.text = "\(eachLeagueMatch[indexPath.row]["score"]["fullTime"]["homeTeam"])"
        }
        
        if "\(eachLeagueMatch[indexPath.row]["score"]["fullTime"]["awayTeam"])" == "null" {
            cell.awayTeamScoreLabel.text = "0"
        } else {
            cell.awayTeamScoreLabel.text = "\(eachLeagueMatch[indexPath.row]["score"]["fullTime"]["awayTeam"])"
        }
        cell.homeTeamImage.image = UIImage(named: "\(eachLeagueMatch[indexPath.row]["homeTeam"]["name"])")
        cell.awayTeamImage.image = UIImage(named: "\(eachLeagueMatch[indexPath.row]["awayTeam"]["name"])")
     
        return cell
    }
    
    
}

extension EachLeagueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
    }
}
