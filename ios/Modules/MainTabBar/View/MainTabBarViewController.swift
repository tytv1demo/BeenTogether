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
        tabBar.isHidden = true

        viewModel = MainTabBarViewModel()
        AppLoadingIndicator.shared.show()
        viewModel.syncData().done { [weak self] in
            self?.setUp()
        }.catch { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }.finally {
            AppLoadingIndicator.shared.hide()
        }
        LocationServices.shared.requestAuthorizationIfNeeded()
    }
    
    func setUp() {
        settupViewController()
        settupTabBarUI()
        selectedIndex = 2
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
        locationVc.viewModel = LocationViewModel(coupleModel: viewModel.coupleModel)
        let locationNav = UINavigationController(rootViewController: locationVc)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        homeVC = storyboard.instantiateViewController()
        
        messageVC = MessageViewController()
        messageVC.viewModel = MessageViewModel(userInfo: AppUserData.shared.userInfo, coupleModel: viewModel.coupleModel)
        let messageNav = UINavigationController(rootViewController: messageVC)
        
        settingVC = SettingViewController()
        settingVC.moduleName = "SettingScreen"
        settingVC.initRCTView()
        let settingImage = UIImage.awesomeIcon(name: .tools, style: .solid)
        let activeSettingImage = UIImage.awesomeIcon(name: .tools, style: .solid, textColor: Colors.kPink)
        settingVC.tabBarItem = UITabBarItem(title: "Settings", image: settingImage, selectedImage: activeSettingImage)
        
        viewControllers = [eventVc, locationNav, homeVC, messageNav, settingVC]
    }
    
    func settupTabBarUI() {
        tabBar.isHidden = false
        tabBar.tintColor = Colors.kPink
        
        homeTabButton = UIButton()
        homeTabImage = UIImageView(image: UIImage.fontAwesomeIcon(name: .heart, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30)))
        homeTabButton.frame = CGRect(x: 0.0, y: 0.0, width: uiConfiguration.centerCircleButtonSize, height: uiConfiguration.centerCircleButtonSize)
        homeTabButton.layer.cornerRadius = uiConfiguration.centerCircleButtonSize * 0.5
        homeTabButton.layer.masksToBounds = true
        homeTabButton.setGradientBackground()
        homeTabButton.dropShadow()
        homeTabButton.addSubview(homeTabImage)
        view.addSubview(homeTabButton)
        homeTabButton.addSubview(homeTabImage)
        let centerPoint = tabBar.center
        let yPoint = centerPoint.y - returnValueByDevice()
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
        let message = "You have been recieved matching request from phone number: \(request.from.phoneNumber) - \(request.from.name)"
        presentConfirmPopup(title: "Matching Request!", message: message, delegate: self, data: request)
    }
    
    func updateHomeTabButtonBehavior() {
        let yPoint = 15
        let transform = selectedIndex != 3 ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: CGFloat(yPoint)).scaledBy(x: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.homeTabButton.transform = transform
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.homeTabButton != nil {
            self.view.bringSubviewToFront(self.homeTabButton)
        }
    }
    deinit {
        obs?.invalidate()
    }
}

extension MainTabBarViewController: ConfirmPopupViewControllerDelegate {
    
    func doAcceptMatchRequest(_ request: CoupleMatchRequest, onPopup popup: ConfirmPopupViewController) -> Promise<Any> {
        return Promise {[weak self] seal in
            viewModel
                .responseToMatchRequest(request: request, action: .accept)
                .done { (success) in
                    if success {
                        popup.dismiss(animated: true, completion: self?.goToSplash)
                 }
            }.catch(seal.reject)
        }
    }
    
    func doCancelMatchRequest(_ request: CoupleMatchRequest, onPopup popup: ConfirmPopupViewController) -> Promise<Any> {
        return Promise {seal in
            viewModel
                .responseToMatchRequest(request: request, action: .reject)
                .done { (success) in
                    if success {
                        popup.dismiss(animated: true, completion: nil)
                    }
                    seal.fulfill(true)
            }.catch(seal.reject)
        }
    }
    
    func confirmPopup(didCancel popup: ConfirmPopupViewController) -> Promise<Any> {
        if let request = popup.data as? CoupleMatchRequest {
            return doCancelMatchRequest(request, onPopup: popup)
        }
        popup.dismiss(animated: true, completion: nil)
        return Promise.value(true)
    }
    
    func confirmPopup(didAccept popup: ConfirmPopupViewController) -> Promise<Any> {
        if let request = popup.data as? CoupleMatchRequest {
            return doAcceptMatchRequest(request, onPopup: popup)
        }
        popup.dismiss(animated: true, completion: goToSplash)
        return Promise.value(true)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateHomeTabButtonBehavior()
    }
    
    
}

extension MainTabBarViewController: MainTabBarViewModelDelegate {
    func mainTabBarViewModel(onLogout viewModel: MainTabBarViewModel) {
        goToSplash()
    }
    
    func mainTabBarViewModel(onFriendAcceptMatchRequest viewModel: MainTabBarViewModel) {
        presentConfirmPopup(title: "Notification", message: "You have just become a couple with another. Reload app sync data?", delegate: self)
    }
}


func returnValueByDevice() -> CGFloat {
    let device = UIDevice()
    if device.userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return 15  //.iPhones: 5_5s_5c_SE
        case 1334:
            return 15  //.iPhones: 6_6s_7_8
        case 1792:
            return 30  //.iPhone: XR_11
        case 1920, 2208:
            return 15  //.iPhones: 6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return 30  //.iPhone: 11Pro
        case 2436:
            return 30  //.iPhones: X_XS
        case 2688:
            return 30  //.iPhones: XSMax_11ProMax
        default:
            return 30
        }
    }
    
    return 30
}
