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
                self.goToHomeScreen()
            } else {
                self.goToLoginScreen()
            }
            self.indicatorView.stopAnimating()
        }
    }
}
