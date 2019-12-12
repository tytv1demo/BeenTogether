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
    func sendText(content: String) -> Promise<RemoteMessage>

    func sendImage(data: Data) -> Promise<RemoteMessage>
}

class BaseMessageRemoteDataSource: MessageRemoteDataSource {
    func sendText(content: String) -> Promise<RemoteMessage> {
        return Promise<RemoteMessage> { seal in
            todoProvider.request(MultiTarget(MessageApi.chat(type: "TEXT", content: content))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let result = try? JSONDecoder().decode(BaseResult<RemoteMessage>.self, from: filteredResponse.data) else {
                            seal.reject(NSError(domain:"", code: 0, userInfo:nil))
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
    
    func sendImage(data: Data) -> Promise<RemoteMessage> {
        return Promise<RemoteMessage> { seal in
            todoProvider.request(MultiTarget(MessageApi.sendImage(data: data))) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        print(String(decoding: filteredResponse.data, as: UTF8.self))
                        guard let result = try? JSONDecoder().decode(BaseResult<RemoteMessage>.self, from: filteredResponse.data) else {
                            seal.reject(NSError(domain:"", code: 0, userInfo:nil))
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
