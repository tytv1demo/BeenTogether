//
//  DashboardView.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit
import RxSwift
import PromiseKit
import UIKit

class MainTabBarUIConfiguration {
    var centerCircleButtonSize: CGFloat = 68
}

class MainTabBarViewController: UITabBarController {
    
    var uiConfiguration: MainTabBarUIConfiguration = MainTabBarUIConfiguration()
    
    var viewModel: MainTabBarViewModel!
    
    var interactionRequest: CoupleMatchRequest!
    
    var homeVC: HomeViewController!
    
    var loginVC: LoginViewController!
    
    var messageVC: MessageViewController!
    
    var settingVC: SettingViewController!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settupViewController()
        settupTabBarUI()
        selectedIndex = 2
        viewModel = MainTabBarViewModel()
        viewModel.delegate = self
        
        subscribeViewModel()
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
    
    func subscribeViewModel() {
        viewModel.coupleMatchRequest.subscribe(onNext: { [weak self] request in
            self?.showMatchRequestPopup(for: request)
        }).disposed(by: disposeBag)
    }
    
    func showMatchRequestPopup(for request: CoupleMatchRequest?) {
        guard let request = request else {
            return
        }
        interactionRequest = request
        let message = "Bạn nhận được yêu cầu ghép đôi từ số điện thoại \(request.from.phoneNumber) - \(request.from.name)"
        presentConfirmPopup(title: "Ghép đôi!", message: message, delegate: self)
    }
}

extension MainTabBarViewController: ConfirmPopupViewControllerDelegate {
    
    func confirmPopup(didCancel popup: ConfirmPopupViewController) -> Promise<Any> {
        return Promise {seal in
            viewModel
                .responseToMatchRequest(request: interactionRequest, action: .reject)
                .done { (success) in
                    if success {
                        popup.dismiss(animated: true, completion: nil)
                    }
                    seal.fulfill(true)
            }.catch(seal.reject)
        }
        
    }
    
    func confirmPopup(didAccept popup: ConfirmPopupViewController) -> Promise<Any> {
        return Promise {seal in
           viewModel
                .responseToMatchRequest(request: interactionRequest, action: .accept)
                .done { (success) in
                    if success {
                        popup.dismiss(animated: true, completion: nil)
                    }
            }.catch(seal.reject)
        }
    }
}

extension MainTabBarViewController: MainTabBarViewModelDelegate {
    func mainTabBarViewModel(onLogout viewModel: MainTabBarViewModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.rootViewController = SplashViewController()
        appDelegate.window?.makeKeyAndVisible()
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
