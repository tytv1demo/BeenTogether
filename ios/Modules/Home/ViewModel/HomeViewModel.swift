//
//  HomeViewModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
import RxSwift

protocol HomeViewModelProtocol: AnyObject {
    var userInfo: User { get set }
    var userRepository: UserRepositoryProtocol { get set }
    var coupleModel: CoupleModel { get set }
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    var userInfo: User
    var userRepository: UserRepositoryProtocol
    var coupleModel: CoupleModel
    
    var userConfig: BehaviorSubject<Config?>
    var friendConfig: BehaviorSubject<Config?>
    var startDate: BehaviorSubject<Double?>

    init(userInfo: User) {
        self.userInfo = userInfo
        userRepository = UserRepository()
        coupleModel = CoupleModel(userInfo: userInfo)
        
        userConfig = coupleModel.userConfig
        friendConfig = coupleModel.friendConfig
        startDate = coupleModel.startDate
    }
}

// MARK: - Handle Date
extension HomeViewModel {
    
    func createDateTimeInterval(from date: Date) -> Double {
        return date.timeIntervalSince1970
    }
    
    func createDateFrom(timeInterval: Double) -> Date {
        return Date(timeIntervalSince1970: Double(timeInterval))
    }
}

// MARK: Handle labels data
extension HomeViewModel {
    
    func createDateCountedString(startDate: Date) -> String {
        guard let dateCounted = Date().days(sinceDate: startDate) else { return "" }
        if dateCounted < 0 { return "undefined" }
        
        let unitString = dateCounted > 1 ? " days" : " day"
        return String(dateCounted) + unitString
    }
    
    func getLeftRightNumbers(startDate: Date) -> (leftNumber: Int, rightNumber: Int) {
        guard let dateCounted = Date().days(sinceDate: startDate) else { return (0, 100) }
        
        if dateCounted < 0 || dateCounted % 100 == dateCounted {
            return (0, 100)
        } else if dateCounted % 100 == 0 {
            return (dateCounted - 100, dateCounted)
        } else {
            let naturalPart = dateCounted / 100
            if naturalPart == 1 {
                return (100, 200)
            } else {
                return (naturalPart * 100, (naturalPart + 1) * 100)
            }
        }
    }
    
    func getProgress(startDate: Date) -> Float {
        guard let dateCounted = Date().days(sinceDate: startDate) else { return 0 }
        
        if dateCounted < 0 {
            return 0
        } else if dateCounted < 100 {
            return Float(dateCounted) / 100
        } else if dateCounted % 100 == 0 {
            return 1
        } else {
            let remainingPart = dateCounted % 100
            return Float(remainingPart) / 100
        }
    }
}
