//
//  PlusMyTeamViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/23.
//

import UIKit
import Kingfisher

class PlusMyTeamViewController: UIViewController {

    var filteredTeam = [FootballTeam]()
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = (searchController?.searchBar.text?.isEmpty == false)
        
        return isActive && isSearchBarHasText
    }
    
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            self.searchTableView.dataSource = self
            self.searchTableView.delegate = self
            self.searchTableView.tableFooterView = UIView(frame: .zero)
            self.searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "팀 이름을 검색하세요"
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.title = "Search"
        self.navigationItem.searchController = searchController

     
    }


}


extension PlusMyTeamViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredTeam.count : FTeam.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        if self.isFiltering {
            cell.teamNameLabel.text = filteredTeam[indexPath.row].name
            cell.teamImage.kf.setImage(with: URL(string: filteredTeam[indexPath.row].imageUrl))
            
        }
        else {
            cell.teamNameLabel.text = FTeam[indexPath.row].name
            cell.teamImage.kf.setImage(with: URL(string: FTeam[indexPath.row].imageUrl))
        }

        
        
        
        return cell
    }
    
    
}

extension PlusMyTeamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if self.isFiltering {
            if !myTeam.contains(filteredTeam[indexPath.row]) {
                myTeam.append(filteredTeam[indexPath.row])
            }
        } else {
            if !myTeam.contains(FTeam[indexPath.row]) {
                myTeam.append(FTeam[indexPath.row])
            }
        }
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
        print(myTeam)
    }
}

extension PlusMyTeamViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.filteredTeam = FTeam.filter { $0.name.lowercased().contains(text) }
        
        self.searchTableView.reloadData()
    }
}
