//
//  SplashNavigator.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol SplashNavigator: AnyObject {
    
}

extension SplashViewController: SplashNavigator {
    
    func goToHomeScreen() {
        let mainVC = MainTabBarViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func goToLoginScreen() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        loginVC = loginStoryboard.instantiateViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
}
