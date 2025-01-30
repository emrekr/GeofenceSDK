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
                DebugLogger.debugPrint("Notification permission error: \(error.localizedDescription)", from: self)
            } else {
                DebugLogger.debugPrint("Notification permission granted: \(granted)", from: self)
            }
        }
    }
    
    func handleGeofenceEvent(locationName: String, eventType: GSEventType) {
        // Prepare notification content
        let content = UNMutableNotificationContent()
        
        // Convert event type to a string
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
            "eventType": eventType.rawValue
        ]
        
        // Ensure unique notification identifier
        let notificationIdentifier = "\(locationName)-\(eventTypeString)"
        
        // Create the notification trigger (fires after 1 second)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the notification request
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        // Add the notification request to the notification center
        notificationCenter.add(request) { error in
            if let error = error {
                DebugLogger.debugPrint("Failed to add notification request: \(error.localizedDescription)", from: self)
            } else {
                DebugLogger.debugPrint("Notification scheduled successfully: \(notificationIdentifier)", from: self)
            }
        }
    }
}
