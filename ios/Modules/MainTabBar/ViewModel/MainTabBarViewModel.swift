//
//  MainTabBarViewModel.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

protocol MainTabBarViewModelDelegate: AnyObject {
    func mainTabBarViewModel(onLogout viewModel: MainTabBarViewModel)
}

protocol MainTabBarViewModelProtocol: AnyObject {
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool>
}

class MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    weak var delegate: MainTabBarViewModelDelegate?
    
    var coupleRepository: CoupleRepository
    
    var userRepository: UserRepository
    
    var coupleMatchRequest: BehaviorSubject<CoupleMatchRequest?>
    
    var coupleModel: CoupleModel

    init() {
        userRepository = UserRepository()
        coupleRepository = CoupleRepository()
        coupleMatchRequest = BehaviorSubject<CoupleMatchRequest?>(value: nil)
        coupleModel = CoupleModel(userInfo: AppUserData.shared.userInfo)
        syncNewestCoupleMatchRequest().done { [weak self] (_) in
            self?.observeNotificatonCenter()
        }.catch {[weak self] (_) in
            self?.observeNotificatonCenter()
        }
    }
    
    func syncData() -> Promise<Void> {
        return when(fulfilled: [coupleModel.syncFriendInfo(friendId: coupleModel.friendId!)]).done { (_) in
            return
        }
    }
    
    @discardableResult
    func syncNewestCoupleMatchRequest() -> Promise<Any> {
        return Promise {seal in
            self.coupleRepository
                .getNewestCoupleMatchRequest()
                .done { (request) in
                    self.coupleMatchRequest.onNext(request)
                    seal.fulfill(true)
            }.catch(seal.reject)
        }
    }
    
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool> {
        return coupleRepository.responseToMatchRequest(request: request, action: action)
    }
    
    func observeNotificatonCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onReceivedNotification), name: NotificationServices.kBroadcastNotificationPayload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUserTokenChanged), name: AppUserData.kUserTokenChangedEvent, object: nil)
    }
    
    @objc func onReceivedNotification(_ notification: Notification) {
        guard let payload = notification.object as? NotificationPayload else {
            return
        }
        if payload.type == .matchReqeust {
            syncNewestCoupleMatchRequest()
        }
    }
    
    @objc func onUserTokenChanged() {
        if AppUserData.shared.userToken == "" {
            delegate?.mainTabBarViewModel(onLogout: self)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
