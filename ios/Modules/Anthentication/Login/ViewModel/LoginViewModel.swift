//
//  LoginViewModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    var userInfo: User { get set }
    var userRepository: UserRepositoryProtocol { get set }
}

class LoginViewModel: NSObject, LoginViewModelProtocol {
    var userInfo = User()
    var userRepository: UserRepositoryProtocol
    
    override init() {
        userRepository = UserRepository()
        
        super.init()
    }
}

extension LoginViewModel {
    
//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2UiOjIzLCJnZW5kZXIiOiJNQUxFIiwiaWQiOjAsImxvY2F0aW9uIjp7ImNvb3JkaW5hdGUiOnsibGF0IjowLCJsbmciOjB9LCJmcm9tIjoxNTc0NTAyODE1NTkzfSwibmFtZSI6IlRy4bqnbiBWxINuIFTDvSIsInBob25lTnVtYmVyIjoiMDM2NTAyMTMwNSIsImlhdCI6MTU3NDU5MDUyMH0.LrZ7oyB4yEzyGkcMP4fxh1O7k10lp5R-ZKGyMWTOFcg"
    
    func signIn(with phoneNumber: String) {
        userRepository
            .signIn(params: UserParams(phoneNumber: "phoneNumber", firebaseToken: ["sdfdsf": "dsaf"]))
            .done { (remoteUser) in
                print(remoteUser)
        }.catch { (err) in
            print(err)
        }
    }
}
