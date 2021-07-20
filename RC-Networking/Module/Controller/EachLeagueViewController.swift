//
//  EachLeagueViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/21.
//

import UIKit
import FSCalendar

class EachLeagueViewController: UIViewController {

    var team: String = ""
    var leagueColorNumber: Int = 0
    var leagueColor: UIColor = .black
    var formatter = DateFormatter()
    
    @IBOutlet weak var calender: FSCalendar! {
        didSet {
            self.calender.delegate = self
            self.calender.dataSource = self
            self.calender.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var matchTableView: UITableView! {
        didSet {
            self.matchTableView.dataSource = self
            self.matchTableView.delegate = self
            self.matchTableView.register(UINib(nibName: "ImageMatchTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageMatchCell")
        }
    }
    @IBOutlet weak var league: UILabel!
    @IBOutlet weak var leagueColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        calender.scope = .week
        calender.appearance.titleFont = UIFont.systemFont(ofSize: 17.0)
        calender.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18.0)
        calender.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        calender.appearance.headerTitleColor = .black
        calender.appearance.weekdayTextColor = .black
        calender.appearance.todayColor = .red
        calender.appearance.selectionColor = leagueColor
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func calenderBtnPressed(_ sender: UIButton) {
        if calender.scope == .week {
            calender.scope = .month
        } else {
            calender.scope = .week
        }
    }
    
}

extension EachLeagueViewController: FSCalendarDataSource {
    
}

extension EachLeagueViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: date))
        
        if calender.scope == .month {
            calender.scope = .week
        }
    }
}

extension EachLeagueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMatchCell", for: indexPath) as! ImageMatchTableViewCell
        
        return cell
    }
    
    
}

extension EachLeagueViewController: UITableViewDelegate {
    
}
