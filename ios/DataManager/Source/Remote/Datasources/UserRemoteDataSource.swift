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
    func signIn(params: SignInParams) -> Promise<SignInResult>
    func signUp(params: SignUpParams) -> Promise<SignInResult>
    func logout() -> Promise<Any>
    func getUserProfile() -> Promise<User>
    func getFriendProfile(friendId: String) -> Promise<User>
    func updateDeviceToken(token: String) -> Promise<Bool>
}

class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    
    func signIn(params: SignInParams) -> Promise<SignInResult> {
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
                    } catch _ {
                        let errorResponse = try? JSONDecoder().decode(NetWorkApiErrorData.self, from: response.data)
                        seal.reject(NetWorkApiError(data: errorResponse))
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func signUp(params: SignUpParams) -> Promise<SignInResult> {
        return Promise<SignInResult> { seal in
            todoProvider.request(MultiTarget(UserAPI.signUp(signUpParams: params))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let result = try? JSONDecoder().decode(BaseResult<SignInResult>.self, from: filteredResponse.data) else {
                            seal.reject(NSError(domain: "", code: 0, userInfo: nil))
                            return
                        }
                        seal.fulfill(result.data)
                    } catch _ {
                        let errorResponse = try? JSONDecoder().decode(NetWorkApiErrorData.self, from: response.data)
                        seal.reject(NetWorkApiError(data: errorResponse))
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
    
    func getFriendProfile(friendId: String) -> Promise<User> {
        return Promise<User> { seal in
            todoProvider.request(MultiTarget(UserAPI.getFriendProfile(friendId: friendId))) { (result) in
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
    
    func updateDeviceToken(token: String) -> Promise<Bool> {
        return Promise { seal in
            todoProvider.request(MultiTarget(UserAPI.updateDeviceToken(token: token))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
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
    
}
