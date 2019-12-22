//
//  SplashViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class SplashViewController: UIViewController {
    
    var loginVC: LoginViewController!
    var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        setupIndicatorView()
        checkSignIn()
    }
    
    func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "login_bg.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupIndicatorView() {
        indicatorView = UIActivityIndicatorView()
        indicatorView.style = .whiteLarge
        
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        indicatorView.startAnimating()
    }
    
    func checkSignIn() {
        _ = AppUserData.shared.checkIsSignedIn().done { (isSignedIn) in
            if isSignedIn {
                let otherId = AppUserData.shared.userInfo.id
                let coupleId = AppUserData.shared.userInfo.coupleId
                let friendId = self.getFriendId(otherId: String(otherId), coupleId: coupleId)
                
//                if friendId != "local" {
                    AppUserData.shared.getFriendProfile(friendId: friendId).done { (_) in
                        self.goToHomeScreen()
                    }.catch { (_) in
                        
                    }
//                } else {
//                    AppUserData.shared.friendInfo = nil
//                    self.goToHomeScreen()
//                }
            } else {
                self.goToLoginScreen()
            }
            self.indicatorView.stopAnimating()
        }
    }

    func getFriendId(otherId: String, coupleId: String) -> String {
        let splitedArray = coupleId.split(separator: "_")
        
        for item in splitedArray {
            if String(item) != otherId {
                return String(item)
            }
        }
        
        return ""
    }
    
}
