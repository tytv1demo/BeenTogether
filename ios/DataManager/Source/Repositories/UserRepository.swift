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
    func getUserProfile(phoneNumber: String) -> Promise<RemoteUser>
    func signIn(params: UserParams) -> Promise<Bool>
}

class UserRepository: UserRepositoryProtocol {
    
    var userRemoteDataSource = UserRemoteDataSource()
    
    func signIn(params: UserParams) -> Promise<Bool> {
        return Promise<Bool> { seal in
            userRemoteDataSource
                .signIn(params: params)
                .done { (_) in
                    seal.fulfill(true)
            }.catch(seal.reject(_:))
        }
    }
    
    func getUserProfile(phoneNumber: String) -> Promise<RemoteUser> {
        return Promise<RemoteUser> { seal in
            userRemoteDataSource
                .getUserProfile(phoneNumber: phoneNumber)
                .done { (user) in
                    seal.fulfill(user)
            }.catch(seal.reject(_:))
        }
    }
    
}
