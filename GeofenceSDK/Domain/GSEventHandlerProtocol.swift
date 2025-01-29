//
//  GSEventHandlerProtocol.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

protocol GSEventHandlerProtocol {
    /// Called when a geofence event occurs.
    /// - Parameters:
    ///   - locationName: The identifier (name) of the location.
    ///   - eventType: An enum (enter/exit).
    func handleGeofenceEvent(locationName: String, eventType: GSEventType)
}
