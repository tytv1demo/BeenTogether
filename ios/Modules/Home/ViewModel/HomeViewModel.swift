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

protocol HomeViewModelProtocol: AnyObject {
    var userInfo: User! { get set }
    var userRepository: UserRepositoryProtocol { get set }
    var dateCouted: Int { get set }
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    
    var userInfo: User!
    var userRepository: UserRepositoryProtocol
    var threadRef: DatabaseReference
    var coupleRef: DatabaseReference
    
    weak var delegate: HomViewControllerDelegate?
    
    var coupleData: [[String: Config]] = []
    
    var configs: [Config] = [] {
        didSet {
            self.delegate?.updateNameLabelCallBack()
        }
    }
    
    var dateCouted: Int = -1 {
        didSet {
            self.delegate?.updateCoutedViewCallBack()
        }
    }
    

    override init() {
        userRepository = UserRepository()
        userInfo = AppUserData.shared.userInfo
        threadRef = Database.database().reference()
        
        
        coupleRef = Database.database().reference(withPath: "couples/\(userInfo.coupleId)/configs")
        super.init()
        
        getConfigDataFromFirebase()
        getStarDateFromFirebase()
    }
    
    func getConfigDataFromFirebase() {
        coupleRef.observe(.value) { (snapshot) in
            guard let rawConfig = snapshot.value as? [String: [String: String]] else { return }
            guard let userConfig = rawConfig[self.userInfo.phoneNumber] else { return }
            guard let friendConfig = rawConfig[AppUserData.shared.friendInfo!.phoneNumber] else { return }
            
            let config = self.firbaseEntityToConfig(raw: userConfig)
            let config1 = self.firbaseEntityToConfig(raw: friendConfig)
            
            self.configs = [config, config1]
        }
    }
    
    func getUserNickName() -> String {
        return configs.first?.name ?? ""
    }
    
    func getFriendNickName() -> String {
        return configs.last?.name ?? ""
    }
}

extension HomeViewModel {
    
    var dateCountedString: String {
        if dateCouted < 0 {
            return ""
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
    
    func getStarDateFromFirebase() {
        let currentDate = Date()
        let startDateRef = Database.database().reference(withPath: "couples/\(userInfo.coupleId)/startDate")
        
        startDateRef.observe(.value) { (snapshot) in
            guard let rawStartDate = snapshot.value else { return }
            guard let timeInterval = rawStartDate as? Double else { return }
            
            let date = Date(timeIntervalSince1970: Double(timeInterval))
            self.dateCouted = currentDate.days(sinceDate: date)!
        }
    }
    
    func createDateTimeIntervalFromString(formattedString: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startDate = dateFormatter.date(from: formattedString)!
        
        return startDate.timeIntervalSince1970
    }
    
    func createDateTime(timestamp: String) -> String {
        var strDate = "undefined"
            
        if let unixTime = Double("1576642227023") {
            let date = Date(timeIntervalSince1970: unixTime)
            
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"
            dateFormatter.timeZone = TimeZone(abbreviation: timezone)
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM dd yyyy"
            strDate = dateFormatter.string(from: date)
        }
            
        return strDate
    }
    
    func getLeftRightNumbers() -> (leftNumber: Int, rightNumber: Int) {
        if dateCouted < 0 || dateCouted % 100 == dateCouted {
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
        if dateCouted < 0 {
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
    
    func refPersonAvatar(avatarURL: String, person: String) -> Promise<Bool> {
        return Promise<Bool> { _ in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/configs/\(person)/avatar")
            
            threadRef.setValue(avatarURL)
        }
    }
    
    func refPersonNickName(name: String, personId: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/configs/\(personId)/name")
            
            threadRef.setValue(name) { (err, _) in
                if err == nil {
                    seal.fulfill(true)
                } else {
                    seal.fulfill(false)
                }
            }
        }
    }
    
    func refBackground(backgroudURL: String) -> Promise<Bool> {
        return Promise<Bool> { _ in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/configs/background")
            
            threadRef.setValue(backgroudURL)
        }
    }
    
    func refCoupleStartDate(startDate: Double) -> Promise<Bool> {
        return Promise<Bool> { _ in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/startDate")
            
            threadRef.setValue(startDate)
        }
    }

    func firbaseEntityToConfig(raw: [String: Any]) -> Config {
        let name: String = String(raw["name"] as! String)
        let avatar: String = String(raw["avatar"] as! String)
        
        return Config(name: name, avatar: avatar)
    }
}
