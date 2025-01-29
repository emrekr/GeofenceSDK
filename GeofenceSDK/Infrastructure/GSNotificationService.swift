//
//  GSNotificationService.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import UserNotifications

final class GSNotificationService: GSEventHandlerProtocol {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        // Request permission right away or from some external call:
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func handleGeofenceEvent(locationName: String, eventType: GSEventType) {
        let content = UNMutableNotificationContent()
        
        // Convert the enum to a string if needed
        let eventTypeString: String
        switch eventType {
        case .enter: eventTypeString = "Enter"
        case .exit:  eventTypeString = "Exit"
        }
        
        content.title = "\(locationName) - \(eventTypeString)"
        content.body  = "You have \(eventTypeString.lowercased())ed \(locationName). Tap for details."
        content.sound = UNNotificationSound.default
        content.userInfo = [
            "locationName": locationName,
            "eventType": eventTypeString
        ]
        
        let request = UNNotificationRequest(
            identifier: "\(locationName)-\(eventTypeString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        notificationCenter.add(request, withCompletionHandler: nil)
    }
}
