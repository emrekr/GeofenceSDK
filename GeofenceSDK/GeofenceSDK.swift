//
//  GeofenceSDK.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import UserNotifications

/// Protocol for GeoGeofence SDK events
public protocol GeoGeofenceSDKDelegate: AnyObject {
    /// Called when the device enters a geofence region
    func geofenceSdk(_ sdk: GeoSDK, didEnterGeofenceWithIdentifier identifier: String)
    /// Called when the device exits a geofence region
    func geofenceSdk(_ sdk: GeoSDK, didExitGeofenceWithIdentifier identifier: String)
}

/// Singleton SDK to handle geofence monitoring
public final class GeoSDK: NSObject {
    
    /// Shared instance
    public static let shared = GeoSDK()
    
    /// Delegate to receive geofence events
    public weak var delegate: GeoGeofenceSDKDelegate?
    
    private let interactor: GSMonitoringUseCase
    
    /// Private initializer to enforce singleton pattern
    private override init() {
        let notificationService = GSNotificationService()
        let locationManagerService = GSLocationManagerService(geofenceEventHandler: notificationService)
        let repository = GSPredefinedLocationRepository()
        self.interactor = GSMonitoringInteractor(locationRepo: repository, locationManagerService: locationManagerService)
        
        super.init()
        
        registerForNotificationTaps()
    }
    
    /// Starts geofence monitoring
    public func startGeofenceMonitoring() async {
        await interactor.startMonitoring()
    }
    
    /// Stops geofence monitoring
    func stopGeofenceMonitoring() {
        interactor.stopMonitoring()
    }
    
    /// Sets up notification handling for geofence events
    private func registerForNotificationTaps() {
        UNUserNotificationCenter.current().delegate = self
    }
}

extension GeoSDK: UNUserNotificationCenterDelegate {
    /// Handles notification interactions
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleGeofenceNotification(response)
        completionHandler()
    }
    
    /// Processes the geofence notification event
    private func handleGeofenceNotification(_ response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        
        guard let locationName = userInfo["locationName"] as? String,
              let eventType = userInfo["eventType"] as? String else {
            return
        }
        
        if eventType == GSEventType.exit.rawValue {
            delegate?.geofenceSdk(self, didExitGeofenceWithIdentifier: locationName)
        } else if eventType == GSEventType.enter.rawValue {
            delegate?.geofenceSdk(self, didEnterGeofenceWithIdentifier: locationName)
        }
        
        stopGeofenceMonitoring()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
