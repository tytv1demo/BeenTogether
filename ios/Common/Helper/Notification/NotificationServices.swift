//
//  NotificationServices.swift
//  Cupid
//
//  Created by Trần Tý on 12/16/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

class NotificationServices: NSObject {
    
    static let shared: NotificationServices = NotificationServices()
    
    var token: String?
    
    var userRepository: UserRepository = UserRepository()
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
          guard granted else { return }
          self?.registerForRemoteNotifications()
      }
    }
    
    func registerForRemoteNotifications() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func notificationServices(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func notificationServices(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken
        updateDeviceToken()
        UNUserNotificationCenter.current().delegate = self
    }

    func updateDeviceToken() {
        InstanceID.instanceID().instanceID { [weak self] (result, error) in
          if let error = error {
            
          } else if let result = result {
            self?.userRepository.updateDeviceToken(token: result.token)
                .done { (_) in
                    
            }.catch { (_) in
                
            }
          }
        }
        
    }
}

extension NotificationServices: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}
