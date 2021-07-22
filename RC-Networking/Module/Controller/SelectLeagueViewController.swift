//
//  SelectLeagueViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/20.
//

import UIKit

let league: [UIImage?] = [UIImage(named: "epl"), UIImage(named: "laliga"),  UIImage(named: "bundesliga"), UIImage(named: "seriea"), UIImage(named: "ligue1")]

class SelectLeagueViewController: UIViewController {
    
    @IBOutlet weak var leagueCollectionView: UICollectionView! {
        didSet {
            self.leagueCollectionView.dataSource = self
            self.leagueCollectionView.delegate = self
            self.leagueCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            self.leagueCollectionView.register(UINib(nibName: "LeagueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LeagueCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SelectLeagueViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        league.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueCell", for: indexPath) as! LeagueCollectionViewCell
        cell.leagueImage.image = league[indexPath.row]
        return cell
    }
    
    
}

extension SelectLeagueViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let leagueVC = self.storyboard?.instantiateViewController(withIdentifier: "LeagueVC") as? EachLeagueViewController else { return }
        leagueVC.modalPresentationStyle = .fullScreen
        
        leagueVC.team = leagueName[indexPath.row]
        leagueVC.leagueColorNumber = indexPath.row
        leagueVC.leagueIndex = indexPath.row
       
        self.navigationController?.pushViewController(leagueVC, animated: true)
    }
}

extension SelectLeagueViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: 400, height: 150)
    }
}
