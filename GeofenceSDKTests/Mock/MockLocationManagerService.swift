//
//  MockLocationManagerService.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

@testable import GeofenceSDK
import CoreLocation

class MockLocationManagerService: GSLocationManagerProtocol {
    var isAuthorized: Bool = true
    var didRequestAuthorizations = false
    var didConfigureGeofences = false
    var didStopMonitoring = false
    var didStartMonitoringForRegion = false
    var didEnterRegionCallback: ((CLRegion) -> Void)?
    var didExitRegionCallback: ((CLRegion) -> Void)?
    
    func requestAuthorizations() async -> Bool {
        didRequestAuthorizations = true
        return isAuthorized
    }
    
    func configureGeofences(locations: [GSLocationEntity], radius: Double) async {
        didConfigureGeofences = true
    }
    
    func stopMonitoring() {
        didStopMonitoring = true
    }
    
    func startMonitoringForRegion(region: CLRegion) {
        didStartMonitoringForRegion = true
    }
    
    func simulateRegionEntry(region: CLRegion) {
        didEnterRegionCallback?(region)
    }
    
    func simulateRegionExit(region: CLRegion) {
        didExitRegionCallback?(region)
    }
}
