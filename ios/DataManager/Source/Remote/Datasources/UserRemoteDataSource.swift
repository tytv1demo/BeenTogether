//
//  UserRemoteDataSource.swift
//  SmileMirror
//
//  Created by Lucas Lee on 8/6/18.
//  Copyright © 2018 OMM. All rights reserved.
//

import UIKit
import Moya
import PromiseKit

protocol UserRemoteDataSourceProtocol: AnyObject {
    func signIn(params: UserParams) -> Promise<SignInResult>
    func signUp(phoneNumber: String, name: String) -> Promise<Bool>
    func logout() -> Promise<Any>
    func getUserProfile() -> Promise<User>
}

class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    
    func signIn(params: UserParams) -> Promise<SignInResult> {
        return Promise<SignInResult> { seal in
            todoProvider.request(MultiTarget(UserAPI.signIn(userParams: params))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let result = try? JSONDecoder().decode(BaseResult<SignInResult>.self, from: filteredResponse.data) else {
                            seal.reject(NSError(domain: "", code: 0, userInfo: nil))
                            return
                        }
                        seal.fulfill(result.data)
                    } catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func signUp(phoneNumber: String, name: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            todoProvider.request(MultiTarget(UserAPI.signUp(phoneNumber: phoneNumber, name: name))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let _ = try? JSONDecoder().decode(BaseResult<SignInResult>.self, from: filteredResponse.data) else {
                            seal.reject(NSError(domain: "", code: 0, userInfo: nil))
                            return
                        }
                        seal.fulfill(true)
                    } catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func logout() -> Promise<Any> {
        return Promise<Any> {_ in
            
        }
    }
    
    func getUserProfile() -> Promise<User> {
        return Promise<User> { seal in
            todoProvider.request(MultiTarget(UserAPI.getUserProfile)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let result = try? JSONDecoder().decode(BaseResult<UserInfoResult>.self, from: filteredResponse.data) else {
                            seal.reject(NSError(domain: "", code: 0, userInfo: nil))
                            return
                        }
                        guard let userInfo = result.data.userInfo else { return }
                        seal.fulfill(userInfo)
                    } catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
