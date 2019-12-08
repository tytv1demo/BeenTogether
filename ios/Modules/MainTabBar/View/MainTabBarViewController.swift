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
    var loginVC: LoginViewController!
    var messageVC: MessageViewController!
    
    var settingVC: SettingViewController!
    
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
        
        let storyboard1 = UIStoryboard(name: "Login", bundle: nil)
        loginVC = storyboard1.instantiateViewController()
        loginVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        homeVC = storyboard.instantiateViewController()
        
        messageVC = MessageViewController()
        let messageNav = UINavigationController(rootViewController: messageVC)

        settingVC = SettingViewController()
        settingVC.moduleName = "SettingScreen"
        settingVC.initRCTView()
        let settingImage = UIImage.awesomeIcon(name: .tools, style: .solid)
        let activeSettingImage = UIImage.awesomeIcon(name: .tools, style: .solid, textColor: Colors.kPink)
        settingVC.tabBarItem = UITabBarItem(title: "Cài đặt", image: settingImage, selectedImage: activeSettingImage)
        
        viewControllers = [firstVc, loginVC, homeVC, messageNav, settingVC]
    }
    
    func settupTabBarUI() {
        let homeTabButton = UIButton()
        let img: UIImageView = UIImageView(image: UIImage(named: "heart"))
        homeTabButton.frame = CGRect(x: 0.0, y: 0.0, width: uiConfiguration.centerCircleButtonSize, height: uiConfiguration.centerCircleButtonSize)
        homeTabButton.layer.cornerRadius = uiConfiguration.centerCircleButtonSize * 0.5
        homeTabButton.layer.masksToBounds = true
        homeTabButton.setGradientBackground()
        homeTabButton.dropShadow()
        homeTabButton.center = CGPoint(x: tabBar.center.x, y: tabBar.center.y - (isIphoneX() ? 40 : 20))
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


func isIphoneX() -> Bool {
    let device = UIDevice()
    if device.userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 2436, 2688, 1792:
            return true
        default:
            return false
        }
    }
    return false
}
