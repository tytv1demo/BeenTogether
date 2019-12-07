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
    func signIn(params: UserParams) -> Promise<Any>
    func signUp(body: Any) -> Promise<Any>
    func logout() -> Promise<Any>
    func getUserProfile(phoneNumber: String) -> Promise<RemoteUser>
}

class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    
    func signIn(params: UserParams) -> Promise<Any> {
        return Promise<Any> { seal in
            todoProvider.request(MultiTarget(UserAPI.signIn(userParams: params))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        seal.fulfill(filteredResponse)
                    } catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func signUp(body: Any) -> Promise<Any> {
        return Promise<Any> {_ in
            
        }
    }
    
    func logout() -> Promise<Any> {
        return Promise<Any> {_ in
            
        }
    }
    
    func getUserProfile(phoneNumber: String) -> Promise<RemoteUser> {
        return Promise<RemoteUser> { seal in
            todoProvider.request(MultiTarget(UserAPI.getUserProfile(phoneNumber: phoneNumber))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let result = try? JSONDecoder().decode(BaseResult<RemoteUser>.self, from: filteredResponse.data) else {
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
}
