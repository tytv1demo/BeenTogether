//
//  LoginViewModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

protocol LoginViewModelProtocol: AnyObject {
    var userRepository: UserRepositoryProtocol { get set }
}

class LoginViewModel: NSObject, LoginViewModelProtocol {
    var userRepository: UserRepositoryProtocol
    
    override init() {
        userRepository = UserRepository()
        
        super.init()
    }
}

extension LoginViewModel {

    func signIn(with userParams: UserParams) -> Promise<Bool> {
        return Promise<Bool> { seal in
            userRepository
                .signIn(params: userParams)
                .done { (result) in
                    AppUserData.shared.userToken = result.token
                    AppUserData.shared.userInfo = result.userInfo
                    seal.fulfill(true)
            }.catch { (err) in
                seal.reject(err)
            }
        }
    }
}
