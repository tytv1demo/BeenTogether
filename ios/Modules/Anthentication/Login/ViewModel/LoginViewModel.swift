//
//  LoginViewModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

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

    func signIn(with phoneNumber: String) {
        userRepository
            .signIn(params: UserParams(phoneNumber: phoneNumber, firebaseToken: ["sdfdsf": "dsaf"]))
            .done { (result) in
                AppUserData.shared.userToken = result.token
                AppUserData.shared.userInfo = result.userInfo
        }.catch { (err) in
            print(err)
        }
    }
}
