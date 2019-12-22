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
    
    init() {
        userRepository = UserRepository()
        coupleRepository = CoupleRepository()
        coupleMatchRequest = BehaviorSubject<CoupleMatchRequest?>(value: nil)
        syncNewestCoupleMatchRequest()
    }
    
    func syncNewestCoupleMatchRequest() {
        self.coupleRepository
            .getNewestCoupleMatchRequest()
            .done { (request) in
                self.coupleMatchRequest.onNext(request)
        }.catch { (_) in
            
        }
    }
    
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool> {
        return coupleRepository.responseToMatchRequest(request: request, action: action)
    }
}
