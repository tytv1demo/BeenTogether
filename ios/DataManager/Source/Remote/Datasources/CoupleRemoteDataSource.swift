//
//  CoupleRemoteDataSource.swift
//  Cupid
//
//  Created by Trần Tý on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

protocol CoupleRemoteDataSourceProtocol: AnyObject {
    func getNewestCoupleMatchRequest() -> Promise<CoupleMatchRequest?>
    
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool>
}

class CoupleRemoteDataSource: CoupleRemoteDataSourceProtocol {
    
    func getNewestCoupleMatchRequest() -> Promise<CoupleMatchRequest?> {
        return Promise { seal in
            todoProvider.request(MultiTarget(CoupleApi.getNewestCoupleMatchRequest)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        guard let result = try? JSONDecoder().decode(BaseResult<GetNewestCoupleMatchRequestResult>.self, from: filteredResponse.data) else {
                            seal.fulfill(nil)
                            return
                        }
                        seal.fulfill(result.data.request)
                    } catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool> {
        return Promise { seal in
            todoProvider.request(MultiTarget(CoupleApi.responseMatchRequest(fromUserId: request.from.id, action: action))) { (result) in
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
