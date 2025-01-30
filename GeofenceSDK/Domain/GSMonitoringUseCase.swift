//
//  GSGeofenceMonitoringUseCase.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import Foundation

/// Protocol defining the geofence monitoring use case.
protocol GSMonitoringUseCase {
    /// Starts monitoring geofences asynchronously.
    func startMonitoring() async
    
    /// Stops monitoring geofences.
    func stopMonitoring()
}
