//
//  NotificationManager.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 21/07/26.
//

import UserNotifications
import SwiftUI

class NotificationManager: NSObject, UNUserNotificationCenterDelegate{
    static let shared = NotificationManager()
    private override init(){
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]){ granted, error in
            if granted{
                print("granted")
            }
            else if let err = error{
                print(err)
            }
            else {
                print("Permission required")
            }
        }
    }
    
    func sendNotification(title:String, body:String, timeInterval:TimeInterval = 5){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error{
                print(error)
            }
        }
    }
    
    func scheduleNotification(title:String, body:String, triggerDate:Date){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error{
                print(error)
            }
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
