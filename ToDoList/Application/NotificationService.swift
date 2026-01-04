//
//  NotificationService.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import Foundation
import UserNotifications
import UIKit

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.badge, .alert, .sound]
        ) { granted, error in
            if granted {
                print("ok notif")
            } else {
                print("no notif")
            }
        }
    }
    
    func updateBadgeCount(_ count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}
