//
//  MockGeofenceEventHandler.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

@testable import GeofenceSDK

class MockGeofenceEventHandler: GSEventHandlerProtocol {
    var handleGeofenceEventCalled = false
    var lastLocationName: String?
    var lastEventType: GSEventType?
    
    func handleGeofenceEvent(locationName: String, eventType: GSEventType) {
        handleGeofenceEventCalled = true
        lastLocationName = locationName
        lastEventType = eventType
    }
}
