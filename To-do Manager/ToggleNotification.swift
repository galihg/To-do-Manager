//
//  Toggle Notification.swift
//  To-do Manager
//
//  Created by MacbookPRO on 04/05/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import Foundation
import UserNotifications

class SetNotification {
    static func toggleNotification(title: String, date: Date, subtitle: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "To-do Manager"
        content.subtitle = subtitle
        content.body = title
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notification temp"
        
        let datecomponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ] , from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil{
                Alert.showMessage(title: "Warning", msg: (error?.localizedDescription)!)
            }
        }
    }
}
