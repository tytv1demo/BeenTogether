//
//  MainTabBarNavigator.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol MainTabBarNavigator: AnyObject {

}

extension MainTabBarViewController: MainTabBarNavigator {
    func goToSplash() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.rootViewController = SplashViewController()
        appDelegate.window?.makeKeyAndVisible()
    }
}
