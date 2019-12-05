//
//  DashboardView.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit
import UIKit

class MainTabBarUIConfiguration {
    var centerCircleButtonSize: CGFloat = 68
}

class MainTabBarViewController: UITabBarController {
    
    var uiConfiguration: MainTabBarUIConfiguration = MainTabBarUIConfiguration()
    
    var homeVC: HomeViewController!
    var messageVC: MessageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settupViewController()
        settupTabBarUI()
        selectedIndex = 2
    }
    
    func settupViewController() {
        let firstVc = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventViewControllerNav") as! UINavigationController
        firstVc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let secVc = UIViewController()
        secVc.view.backgroundColor = .white
        secVc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        homeVC = storyboard.instantiateViewController()
        
        messageVC = MessageViewController()
        let messageNav = UINavigationController(rootViewController: homeVC)
        messageNav.viewControllers = [messageVC]
        
        let fifthVc = UIViewController()
        fifthVc.view.backgroundColor = .red
        fifthVc.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)
        
        viewControllers = [firstVc, secVc, homeVC, messageNav, fifthVc]
    }
    
    func settupTabBarUI() {
        let homeTabButton = UIButton()
        let img: UIImageView = UIImageView(image: UIImage(named: "heart"))
        homeTabButton.frame = CGRect(x: 0.0, y: 0.0, width: uiConfiguration.centerCircleButtonSize, height: uiConfiguration.centerCircleButtonSize)
        homeTabButton.layer.cornerRadius = uiConfiguration.centerCircleButtonSize * 0.5
        homeTabButton.layer.masksToBounds = true
        homeTabButton.setGradientBackground()
        homeTabButton.dropShadow()
        homeTabButton.center = CGPoint(x: tabBar.center.x, y: tabBar.center.y - 40)
        homeTabButton.addSubview(img)
        img.center = homeTabButton.center
        view.addSubview(homeTabButton)
        view.addSubview(img)
        homeTabButton.addTarget(self, action: #selector(onHomTabButtonTapped), for: [.touchUpInside])
        
        messageVC.tabBarItem =  UITabBarItem(title: "", image: UIImage(named: "message"), selectedImage: UIImage(named: "message"))
    }
    
    @objc func onHomTabButtonTapped() {
        selectedIndex = 2
    }
}
