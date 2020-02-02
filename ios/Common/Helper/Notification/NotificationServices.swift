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

enum NotificationPayloadType: String {
    case message
    case matchReqeust
    case coupleMatch
}

struct NotificationPayload {
    var type: NotificationPayloadType
    var payload: Any?
}

class NotificationServices: NSObject {
    
    static let shared: NotificationServices = NotificationServices()
    
    static let kBroadcastNotificationPayload = NSNotification.Name(rawValue: "NotificationService-Payload-Broadcast")
    
    var token: String?
    
    var userRepository: UserRepository = UserRepository()
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
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
          if let _ = error {
            
          } else if let result = result {
            self?.userRepository.updateDeviceToken(token: result.token)
                .done { (_) in
                    
            }.catch { (_) in
                
            }
          }
        }
        
    }
    
    func postNotificationPayload(_ userInfo: [String: Any]) {
        guard
            let rawType = userInfo["type"] as? String,
            let type = NotificationPayloadType(rawValue: rawType) else {
            return
        }
        let notificationPayload = NotificationPayload(type: type, payload: nil)
        
        NotificationCenter.default.post(name: NotificationServices.kBroadcastNotificationPayload, object: notificationPayload)
    }
}

extension NotificationServices: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
  
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            completionHandler()
            return
        }
        postNotificationPayload(userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {            return
        }
        postNotificationPayload(userInfo)
        completionHandler(.sound)
    }
}
