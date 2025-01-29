//
//  GeofenceSDK.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import UserNotifications

public protocol GeoGeofenceSDKDelegate {
    func geofenceSdk(_ sdk: GeoSDK, didEnterGeofenceWithIdentifier identifier: String)
    func geofenceSdk(_ sdk: GeoSDK, didExitGeofenceWithIdentifier identifier: String)
}

public final class GeoSDK: NSObject {
    public static let shared = GeoSDK()
    public var delegate: GeoGeofenceSDKDelegate?
    
    public func startGeofenceMonitoring() {
        interactor.startMonitoring()
    }
    
    func stopGeofenceMonitoring() {
        interactor.stopMonitoring()
    }
    
    // Private
    private let interactor: GSMonitoringUseCase
    
    private override init() {
        let notificationService = GSNotificationService()
        let locationManagerService = GSLocationManagerService(geofenceEventHandler: notificationService)
        let repository = GSPredefinedLocationRepository()
        self.interactor = GSMonitoringInteractor(locationRepo: repository, locationManagerService: locationManagerService)
        
        super.init()
        
        registerForNotificationTaps()
    }
    
    private func registerForNotificationTaps() {
        UNUserNotificationCenter.current().delegate = self
    }
}

extension GeoSDK: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Stop geofencing
        stopGeofenceMonitoring()
        let userInfo = response.notification.request.content.userInfo
        if let locationName = userInfo["locationName"] as? String,
           let eventType = userInfo["eventType"] as? String {
            if eventType == GSEventType.exit.rawValue {
                self.delegate?.geofenceSdk(self, didExitGeofenceWithIdentifier: locationName)
            } else if eventType == GSEventType.enter.rawValue {
                self.delegate?.geofenceSdk(self, didEnterGeofenceWithIdentifier: locationName)
            }
        }
        // Clear notifications
        center.removeAllDeliveredNotifications()
        
        completionHandler()
    }
}
