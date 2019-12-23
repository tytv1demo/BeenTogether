//
//  CoupleRepository.swift
//  Cupid
//
//  Created by Trần Tý on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

protocol CoupleRepositoryProtocol: AnyObject {
    func getNewestCoupleMatchRequest() -> Promise<CoupleMatchRequest?>
    
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool>
}

class CoupleRepository: CoupleRepositoryProtocol {
    
    var coupleRemoteDataSource = CoupleRemoteDataSource()
    
    func getNewestCoupleMatchRequest() -> Promise<CoupleMatchRequest?> {
        return coupleRemoteDataSource.getNewestCoupleMatchRequest()
    }
    
    func responseToMatchRequest(request: CoupleMatchRequest, action: MatchRequestAction) -> Promise<Bool> {
        return coupleRemoteDataSource.responseToMatchRequest(request: request, action: action)
    }
}