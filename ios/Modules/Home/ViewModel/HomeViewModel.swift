//
//  HomeViewModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase

protocol HomeViewModelProtocol: AnyObject {
    var userInfo: User { get set }
    var userRepository: UserRepositoryProtocol { get set }
    var dateCouted: Int { get set }
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    var userInfo = User()
    var userRepository: UserRepositoryProtocol
    
    var dateCouted = 0
    
    var threadRef: DatabaseReference
    
    override init() {
        userRepository = UserRepository()
        
        if let phoneNumber = userInfo.phoneNumber {
            threadRef = Database.database().reference(withPath: "user/\(phoneNumber)")
        } else {
            threadRef = DatabaseReference()
        }
        
        super.init()
        
        loadData()
    }
    
    func loadData() {
        userRepository
            .getUserProfile(phoneNumber: "0365021305")
            .done { (remoteUser) in
                self.dateCouted = remoteUser.age! * 10
                
                NotificationCenter.default.post(name: NSNotification.Name("FetchUserInfoSuccessfully"), object: nil)
        }.catch { (err) in
            print(err)
        }
    }
    
}

extension HomeViewModel {
    
    var dateCountedString: String {
        if dateCouted == 0 {
            return "0 day"
        }
        
        let unitString = dateCouted > 1 ? " days" : " day"
        return String(dateCouted) + unitString
    }
    
//    func calculateDate() -> Int {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        startDate = dateFormatter.date(from: startDateString)!
//
//        dateCouted = countDays(from: startDate)
//
//        return dateCouted
//    }
    
//    func countDays(from startDate: Date?) -> Int {
//        if let startDate = startDate, startDate < currentDate {
//            return currentDate.days(sinceDate: startDate) ?? 0
//        }
//
//        return 0
//    }
    
    
    func getLeftRightNumbers() -> (leftNumber: Int, rightNumber: Int) {
        if dateCouted == 0 || dateCouted % 100 == dateCouted {
            return (0, 100)
        } else if dateCouted % 100 == 0 {
            return (dateCouted - 100, dateCouted)
        } else {
            let naturalPart = dateCouted / 100
            if naturalPart == 1 {
                return (100, 200)
            } else {
                return (naturalPart * 100, (naturalPart + 1) * 100)
            }
        }
    }
    
    func getProgress() -> Float {
        if dateCouted == 0 {
            return 0
        } else if dateCouted < 100 {
            return Float(dateCouted) / 100
        } else if dateCouted % 100 == 0 {
            return 1
        } else {
            let remainingPart = dateCouted % 100
            return Float(remainingPart) / 100
        }
    }
}
