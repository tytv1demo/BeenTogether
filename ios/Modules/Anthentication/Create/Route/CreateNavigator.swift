//
//  CreateNavigator.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol CreateNavigator: AnyObject {
    
}

extension CreateViewController: CreateNavigator {
    
    func goToHomeScreen() {
        let mainVC = MainTabBarViewController()
        mainVC.isTheFirstTime = true
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
}
