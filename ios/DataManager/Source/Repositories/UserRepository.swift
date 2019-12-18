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
    func getFriendProfile(friendId: String) -> Promise<User>
    func signIn(params: SignInParams) -> Promise<SignInResult>
    func signUp(params: SignUpParams) -> Promise<SignInResult>
    func updateDeviceToken(token: String) -> Promise<Bool>
}

class UserRepository: UserRepositoryProtocol {
    
    var userRemoteDataSource = UserRemoteDataSource()
    
    func signIn(params: SignInParams) -> Promise<SignInResult> {
        return Promise<SignInResult> { seal in
            userRemoteDataSource
                .signIn(params: params)
                .done { (user) in
                    seal.fulfill(user)
            }.catch(seal.reject(_:))
        }
    }
    
    func signUp(params: SignUpParams) -> Promise<SignInResult> {
        return Promise<SignInResult> { seal in
            userRemoteDataSource
                .signUp(params: params)
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
    
    func getFriendProfile(friendId: String) -> Promise<User> {
        return Promise<User> { seal in
            userRemoteDataSource
                .getFriendProfile(friendId: friendId)
                .done { (user) in
                    seal.fulfill(user)
            }.catch(seal.reject(_:))
        }
    }
    
    func updateDeviceToken(token: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            userRemoteDataSource
                .updateDeviceToken(token: token)
                .done { (success) in
                    seal.fulfill(success)
            }.catch(seal.reject)
        }
    }
}
