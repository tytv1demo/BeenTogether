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
import RxCocoa
import UIKit

class MainTabBarUIConfiguration {
    var centerCircleButtonSize: CGFloat = 58
}
protocol CustomTabBarDelegate: AnyObject {
    func tabBar(_ tabBar: CustomTabBar, didSetHidden isHidden: Bool)
}

class CustomTabBar: UITabBar {
    
    weak var customDelegate: CustomTabBarDelegate?
    
    override var isHidden: Bool {
        didSet {
            customDelegate?.tabBar(self, didSetHidden: self.isHidden)
        }
    }
}

class MainTabBarViewController: UITabBarController {
    
    var uiConfiguration: MainTabBarUIConfiguration = MainTabBarUIConfiguration()
    
    var viewModel: MainTabBarViewModel!
    
    var interactionRequest: CoupleMatchRequest!
    
    var eventVc: UINavigationController!
    
    var homeVC: HomeViewController!
    
    var locationVc: LocationViewController!
    
    var messageVC: MessageViewController!
    
    var settingVC: SettingViewController!
    
    var homeTabButton: UIButton!
    
    var homeTabImage: UIImageView!
    
    var obs: NSKeyValueObservation!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settupViewController()
        settupTabBarUI()
        selectedIndex = 2
        viewModel = MainTabBarViewModel()
        viewModel.delegate = self
        delegate = self
        subscribeViewModel()
        obs = tabBar.observe(\.isHidden) { (_, _) in
            self.homeTabButton.isHidden = self.tabBar.isHidden
        }
    }
    
    func settupViewController() {
        eventVc = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventViewControllerNav") as! UINavigationController
        
        locationVc = LocationViewController()
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        homeVC = storyboard.instantiateViewController()
        
        messageVC = MessageViewController()
        let messageNav = UINavigationController(rootViewController: messageVC)
        
        settingVC = SettingViewController()
        settingVC.moduleName = "SettingScreen"
        settingVC.initRCTView()
        let settingImage = UIImage.awesomeIcon(name: .tools, style: .solid)
        let activeSettingImage = UIImage.awesomeIcon(name: .tools, style: .solid, textColor: Colors.kPink)
        settingVC.tabBarItem = UITabBarItem(title: "Settings", image: settingImage, selectedImage: activeSettingImage)
        
        viewControllers = [eventVc, locationVc, homeVC, messageNav, settingVC]
    }
    
    func settupTabBarUI() {
        tabBar.tintColor = Colors.kPink
        
        homeTabButton = UIButton()
        homeTabImage = UIImageView(image: UIImage(named: "heart"))
        homeTabButton.frame = CGRect(x: 0.0, y: 0.0, width: uiConfiguration.centerCircleButtonSize, height: uiConfiguration.centerCircleButtonSize)
        homeTabButton.layer.cornerRadius = uiConfiguration.centerCircleButtonSize * 0.5
        homeTabButton.layer.masksToBounds = true
        homeTabButton.setGradientBackground()
        homeTabButton.dropShadow()
        homeTabButton.addSubview(homeTabImage)
        view.addSubview(homeTabButton)
        homeTabButton.addSubview(homeTabImage)
        let centerPoint = tabBar.center
        let yPoint = centerPoint.y - (isIphoneX() ? 40 : 20)
        homeTabButton.center = CGPoint(x: centerPoint.x, y: yPoint)
        homeTabImage.snp.makeConstraints { (make) in
            make.center.equalTo(homeTabButton)
        }
        homeVC.tabBarItem = UITabBarItem()
        homeTabButton.addTarget(self, action: #selector(onHomTabButtonTapped), for: [.touchUpInside])
        
        eventVc.tabBarItem = UITabBarItem(title: "Events", image: UIImage.awesomeIcon(name: .stickyNote), selectedImage: UIImage.awesomeIcon(name: .stickyNote))
        
        locationVc.tabBarItem = UITabBarItem(title: "Location", image: UIImage.awesomeIcon(name: .locationArrow), selectedImage: UIImage.awesomeIcon(name: .locationArrow, textColor: Colors.kPink))
        messageVC.tabBarItem =  UITabBarItem(title: "Messages", image: UIImage(named: "message"), selectedImage: UIImage(named: "message"))
    }
    
    @objc func onHomTabButtonTapped() {
        selectedIndex = 2
        updateHomeTabButtonBehavior()
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
    
    func updateHomeTabButtonBehavior() {
        let yPoint = isIphoneX() ? 15 : 30
        let transform = selectedIndex != 3 ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: CGFloat(yPoint)).scaledBy(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.homeTabButton.transform = transform
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bringSubviewToFront(self.homeTabButton)
    }
    deinit {
        obs.invalidate()
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

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateHomeTabButtonBehavior()
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
