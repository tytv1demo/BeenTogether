//
//  UserRepository.swift
//  SmileMirror
//
//  Created by Lucas Lee on 8/6/18.
//  Copyright © 2018 OMM. All rights reserved.
//

import UIKit
import PromiseKit

protocol UserRepositoryProtocol: AnyObject {
    func getUserProfile() -> Promise<User>
    func signIn(params: UserParams) -> Promise<SignInResult>
}

class UserRepository: UserRepositoryProtocol {
    
    var userRemoteDataSource = UserRemoteDataSource()
    
    func signIn(params: UserParams) -> Promise<SignInResult> {
        return Promise<SignInResult> { seal in
            userRemoteDataSource
                .signIn(params: params)
                .done { (user) in
                    seal.fulfill(user)
            }.catch(seal.reject(_:))
        }
    }
    
    func getUserProfile() -> Promise<User> {
        return Promise<User> { seal in
            userRemoteDataSource
                .getUserProfile()
                .done { (user) in
                    seal.fulfill(user)
            }.catch(seal.reject(_:))
        }
    }
    
}
