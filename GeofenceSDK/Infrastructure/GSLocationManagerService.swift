//
//  GSLocationManagerService.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import CoreLocation

/// This class handles the iOS-level details of geofence monitoring
final class GSLocationManagerService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let geofenceEventHandler: GSEventHandlerProtocol
    
    init(geofenceEventHandler: GSEventHandlerProtocol) {
        self.geofenceEventHandler = geofenceEventHandler
        super.init()
        locationManager.delegate = self
    }
    
    // Request the necessary authorizations
    func requestAuthorizations() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            // Optionally handle the scenario if user denied location
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // Stop previous monitoring, then start new monitoring
    func configureGeofences(locations: [GSLocationEntity], radius: Double) {
        // Stop monitoring any existing regions
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        
        // Start monitoring new regions
        for loc in locations {
            let region = CLCircularRegion(center: loc.coordinate, radius: radius, identifier: loc.name)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            locationManager.startMonitoring(for: region)
        }
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    func stopMonitoring() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
            DebugLogger.debugPrint("Monitoring stoped for region: \(region)", from: self)
        }
    }
}

extension GSLocationManagerService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied, .authorizedAlways, .authorized:
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }
        geofenceEventHandler.handleGeofenceEvent(locationName: circularRegion.identifier, eventType: .enter)
        DebugLogger.debugPrint("didEnterRegion: \(region)", from: self)
        GeoSDK.shared.delegate?.geofenceSdk( GeoSDK.shared, didEnterGeofenceWithIdentifier: circularRegion.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }
        geofenceEventHandler.handleGeofenceEvent(locationName: circularRegion.identifier, eventType: .exit)
        DebugLogger.debugPrint("didExitRegion: \(region)", from: self)
        GeoSDK.shared.delegate?.geofenceSdk(GeoSDK.shared, didExitGeofenceWithIdentifier: circularRegion.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        DebugLogger.debugPrint("Monitoring failed for region: \(String(describing: region?.identifier)) error: \(error)", from: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        DebugLogger.debugPrint("didStartMonitoringFor region: \(region)", from: self)
    }
}
