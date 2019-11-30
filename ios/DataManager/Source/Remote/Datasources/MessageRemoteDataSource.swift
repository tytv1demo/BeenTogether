//
//  MessageRemoteDataSource.swift
//  Cupid
//
//  Created by Trần Tý on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

protocol MessageRemoteDataSource: AnyObject {
    func chat(type: MessageType, content: String) -> Promise<Any>
}

class BaseMessageRemoteDataSource: MessageRemoteDataSource {
    func chat(type: MessageType, content: String) -> Promise<Any> {
        return Promise<Any> { seal in
            todoProvider.request(MultiTarget(MessageApi.chat(type: type.rawValue, content: content))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
//                        let tasks = try filteredResponse.map([Task].self, failsOnEmptyData: false)
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
}
