//
//  LoginNavigator.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol LoginNavigator: AnyObject {
    
}

extension LoginViewController: LoginNavigator {
    
    func goToHomeScreen() {
        let mainVC = MainTabBarViewController()
        mainVC.isTheFirstTime = true
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func goToCreateScreen() {
        let createStoryboard = UIStoryboard(name: "Create", bundle: nil)
        createVC = createStoryboard.instantiateViewController()
        let navigationController = UINavigationController(rootViewController: createVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
}
