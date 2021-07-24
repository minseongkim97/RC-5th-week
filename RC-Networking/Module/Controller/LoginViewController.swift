//
//  ViewController.swift
//  RC-Networking
//
//  Created by MIN SEONG KIM on 2021/07/18.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaoSDKAuth
import KakaoSDKUser
import FBSDKLoginKit

var name: String = ""
var email: String = ""
class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let loginButton = FBLoginButton()
//        loginButton.permissions = ["public_profile", "email"]
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
        

    }
    
 
    
    @IBAction func kakaoLoginBtnPressed(_ sender: UIButton) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        let _ = oauthToken?.accessToken
                        self.setUserInfo()
                        guard let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") else { return }
                        tabbarVC.modalPresentationStyle = .fullScreen
                        self.present(tabbarVC, animated: true)
                    }
                }
        }

    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        LoginManager.init().logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in

            switch loginResult {

            case .failed(let error):

                print(error)

            case .cancelled:

                print("유저 캔슬")

            case .success(let grantedPermissions, let declinedPermissions, let accessToken):

                print("로그인 성공")
                let params = ["fields" : "id,name,email"]

                GraphRequest(graphPath: "me", parameters: params).start { connection, result, error in
                    if (error != nil) {
                                // 로그인 에러
                                return
                            }
                    guard let facebook = result as? [String: AnyObject] else { return }

                    let token = facebook["id"] as? String
                    name = (facebook["name"] as? String)!
                    email = (facebook["email"] as? String)!
                }

                
                guard let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") else { return }
                tabbarVC.modalPresentationStyle = .fullScreen
                self.present(tabbarVC, animated: true)

            }

        }
    }
    
    @IBAction func unwindVC1 (_ segue : UIStoryboardSegue) {}
    
    func setUserInfo() {
        UserApi.shared.me { user, error in
            if let error = error {
                print(error)
            } else {
                print("me() succes.")
                _ = user
                name = "\(user?.kakaoAccount?.profile?.nickname ?? "") 님"
                email = "\(user?.kakaoAccount?.email ?? "")"
            }
        }
    }
}

