//
//  MeViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices
import KakaoSDKAuth
import KakaoSDKUser
import FBSDKLoginKit
import KakaoSDKCommon

var myTeam = [FootballTeam]()

class MeViewController: UIViewController {
    var news = [JSON]()

    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            self.searchTableView.dataSource = self
            self.searchTableView.delegate = self
            self.searchTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        }
    }
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var myTeamCollectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            self.myTeamCollectionView.dataSource = self
            self.myTeamCollectionView.delegate = self
            self.myTeamCollectionView.collectionViewLayout = layout
            self.myTeamCollectionView.register(UINib(nibName: "MyTeamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyTeamCollectionViewCell")

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewwillappear")
        self.myTeamCollectionView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
        print(myTeam)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameLabel.text = name
        emailLabel.text = email
        fetchNewsData()
        
    }
    
    func fetchNewsData() {
        
        AF.request(searchURL, method: .get, parameters: ["query":"유럽 축구", "display":20],headers: searchKeyHeader
        ).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                for new in json["items"].arrayValue {
                    self.news.append(new)
                }
                
                
                self.searchTableView.reloadData()
                
              

            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func myTeamPlusBtmPressed(_ sender: UIButton) {
        guard let plusMyTeamVC = self.storyboard?.instantiateViewController(withIdentifier: "PlusMyTeamViewController") as? PlusMyTeamViewController else { return }
        plusMyTeamVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(plusMyTeamVC, animated: true)
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "LOGOUT", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: "YES", style: .default) { _ in
            
            if let token = AccessToken.current, !token.isExpired {
                LoginManager().logOut()
                myTeam = []
                self.performSegue(withIdentifier: "unwindVC1", sender: self)
            }
            
            if (AuthApi.hasToken()) {
                UserApi.shared.accessTokenInfo { (_, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            //로그인 필요
                        }
                        else {
                            //기타 에러
                        }
                    }
                    else {
                        //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                        UserApi.shared.logout {(error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("logout() success.")
                                myTeam = []
                                self.performSegue(withIdentifier: "unwindVC1", sender: self)

                            }
                        }
                    }
                }
            }
            else {
                //로그인 필요
            }
                
           


        }
        let stayAction = UIAlertAction(title: "STAY", style: .destructive, handler: nil)

        alert.addAction(stayAction)
        alert.addAction(logoutAction)

        self.present(alert, animated: true, completion: nil)
    }
    

}

extension MeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myTeam.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyTeamCollectionViewCell", for: indexPath) as! MyTeamCollectionViewCell
        
        // 이미지 고쳐야함
        cell.myTeamImage.image = UIImage(named: myTeam[indexPath.row].name)
//        cell.myTeamImage.layer.cornerRadius = cell.frame.height/3
        return cell
    }
    
    
    
}

extension MeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let teamMatchVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamMatchViewController") as? TeamMatchViewController else { return }
       
        teamMatchVC.teamID = myTeam[indexPath.row].id
        self.navigationController?.pushViewController(teamMatchVC, animated: true)
    }

}

extension MeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = collectionView.frame.size.width / 5
        return CGSize(width: size, height: size)
    }
    
}

extension MeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.titleLabel.text = news[indexPath.row]["title"].stringValue.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "&quot;", with: "")
        cell.descriptionLabel.text = news[indexPath.row]["description"].stringValue.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "&quot;", with: "")
        cell.dateLabel.text = "\(news[indexPath.row]["pubDate"].stringValue[String.Index(utf16Offset: 0, in: news[indexPath.row]["pubDate"].stringValue)...String.Index(utf16Offset: 24, in: news[indexPath.row]["pubDate"].stringValue)])"
        return cell
    }
    
    
}

extension MeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = news[indexPath.row]["link"].stringValue
        if let url = URL(string: link) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
}
