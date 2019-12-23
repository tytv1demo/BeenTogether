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

protocol MainTabBarViewModelProtocol: AnyObject {
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool>
}

class MainTabBarViewModel: MainTabBarViewModelProtocol {
    var coupleRepository: CoupleRepository
    
    var userRepository: UserRepository
    
    var coupleMatchRequest: BehaviorSubject<CoupleMatchRequest?>
    
    var notificationPayloadObservation: NSObjectProtocol!
    
    init() {
        userRepository = UserRepository()
        coupleRepository = CoupleRepository()
        coupleMatchRequest = BehaviorSubject<CoupleMatchRequest?>(value: nil)
        syncNewestCoupleMatchRequest().done { [weak self] (_) in
            self?.observeNotificatonCenter()
        }.catch {[weak self] (_) in
            self?.observeNotificatonCenter()
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
    }
    
    @objc func onReceivedNotification(_ notification: Notification) {
        guard let payload = notification.object as? NotificationPayload else {
            return
        }
        if payload.type == .matchReqeust {
            syncNewestCoupleMatchRequest()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
