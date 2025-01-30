//
//  MockLocationManagerService.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

@testable import GeofenceSDK

class MockLocationManagerService: GSLocationManagerProtocol {
    var isAuthorized: Bool = true
    var didRequestAuthorizations = false
    var didConfigureGeofences = false
    var didStopMonitoring = false
    
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
}
