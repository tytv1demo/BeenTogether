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

}

class MainTabBarViewModel: MainTabBarViewModelProtocol {
    var userRepository: UserRepository
    
    var coupleMatchRequest: BehaviorSubject<CoupleMatchRequest?>
    
    init() {
        userRepository = UserRepository()
        coupleMatchRequest = BehaviorSubject<CoupleMatchRequest?>(value: nil)
        syncNewestCoupleMatchRequest()
    }
    
    func syncNewestCoupleMatchRequest() {
        self.userRepository
            .getNewestCoupleMatchRequest()
            .done { (request) in
                self.coupleMatchRequest.onNext(request)
        }.catch { (_) in
            
        }
    }
}
