//
//  DashboardView.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit

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
  }
  
  func settupViewController(){
    let firstVc = UIViewController()
    firstVc.view.backgroundColor = .blue
    firstVc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
    let secVc = UIViewController()
    secVc.view.backgroundColor = .white
    secVc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
    
    homeVC = HomeViewController()
    
    messageVC = MessageViewController()
    let messageNav = UINavigationController(rootViewController: homeVC)
    messageNav.viewControllers = [messageVC]
    
    let fifthVc = UIViewController()
    fifthVc.view.backgroundColor = .red
    fifthVc.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)
    
    viewControllers = [firstVc, secVc, homeVC, messageNav, fifthVc]
  }
  
  func settupTabBarUI(){
    let homeTabButton = UIButton()
    homeTabButton.frame = CGRect(x: 0.0, y: 0.0, width: uiConfiguration.centerCircleButtonSize, height: uiConfiguration.centerCircleButtonSize)
    homeTabButton.layer.cornerRadius = uiConfiguration.centerCircleButtonSize * 0.5
    homeTabButton.layer.masksToBounds = true
    homeTabButton.setGradientBackground()
    homeTabButton.dropShadow()
    homeTabButton.center = CGPoint(x: tabBar.center.x, y: tabBar.center.y - 40)
    
    view.addSubview(homeTabButton)
    homeTabButton.addTarget(self, action: #selector(onHomTabButtonTapped), for: [.touchUpInside])
    
    messageVC.tabBarItem =  UITabBarItem(title: "", image: UIImage(named: "message"), selectedImage: UIImage(named: "message"))
  }
  
  @objc func onHomTabButtonTapped(){
    selectedIndex = 2
  }
}



