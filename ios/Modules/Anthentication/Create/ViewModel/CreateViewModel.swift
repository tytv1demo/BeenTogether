//
//  CreateViewModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

protocol CreateViewModelProtocol: AnyObject {
    var userRepository: UserRepositoryProtocol { get set }
}

class CreateViewModel: NSObject, CreateViewModelProtocol {
    var userRepository: UserRepositoryProtocol
    
    override init() {
        userRepository = UserRepository()
        
        super.init()
    }
}

extension CreateViewModel {

    func signUp(with userParams: SignUpParams) -> Promise<Bool> {
        return Promise<Bool> { seal in
            userRepository
                .signUp(params: userParams)
                .done { (result) in
                    AppUserData.shared.userToken = result.token
                    AppUserData.shared.userInfo = result.userInfo
                    NotificationServices.shared.registerForPushNotifications()
                    seal.fulfill(true)
            }.catch { (err) in
                seal.reject(err)
            }
        }
    }
}
