//
//  GSLocationManagerServiceTests.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

import XCTest
@testable import GeofenceSDK
@testable import GeofenceExampleApp
import CoreLocation

class GSLocationManagerServiceTests: XCTestCase {
    
    var locationManagerService: GSLocationManagerService!
    var mockLocationManagerService: MockLocationManagerService!
    var mockGeofenceEventHandler: MockGeofenceEventHandler!
    
    override func setUp() {
        super.setUp()
        mockLocationManagerService = MockLocationManagerService()
        mockGeofenceEventHandler = MockGeofenceEventHandler()
        locationManagerService = GSLocationManagerService(geofenceEventHandler: mockGeofenceEventHandler)
    }
    
    override func tearDown() {
        locationManagerService = nil
        mockLocationManagerService = nil
        mockGeofenceEventHandler = nil
        super.tearDown()
    }
    
    func testRequestAuthorization_WhenAuthorized() async {
        // Given
        mockLocationManagerService.isAuthorized = true
        
        // When
        let result = await locationManagerService.requestAuthorizations()
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didRequestAuthorizations)
        XCTAssertTrue(result)
    }
    
    func testRequestAuthorization_WhenNotAuthorized() async {
        // Given
        mockLocationManagerService.isAuthorized = false
        
        // When
        let result = await locationManagerService.requestAuthorizations()
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didRequestAuthorizations)
        XCTAssertFalse(result)
    }
    
    func testConfigureGeofences() async {
        // Given
        let locations = [
            GSLocationEntity(name: "Test Location", coordinate: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0))
        ]
        
        // When
        await locationManagerService.configureGeofences(locations: locations, radius: 100.0)
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didConfigureGeofences)
    }
    
    func testStopMonitoring() {
        // When
        locationManagerService.stopMonitoring()
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didStopMonitoring)
    }
    
    func testRegionEntryEvent() {
        // Given
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0), radius: 100.0, identifier: "Test Location")
        mockLocationManagerService.didEnterRegionCallback = { region in
            XCTAssertEqual(region.identifier, "Test Location")
        }
        
        // When
        mockLocationManagerService.simulateRegionEntry(region: region)
        
        // Then
        XCTAssertTrue(mockGeofenceEventHandler.handleGeofenceEventCalled)
        XCTAssertEqual(mockGeofenceEventHandler.lastLocationName, "Test Location")
        XCTAssertEqual(mockGeofenceEventHandler.lastEventType, .enter)
    }
    
    func testRegionExitEvent() {
        // Given
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0), radius: 100.0, identifier: "Test Location")
        mockLocationManagerService.didExitRegionCallback = { region in
            XCTAssertEqual(region.identifier, "Test Location")
        }
        
        // When
        mockLocationManagerService.simulateRegionExit(region: region)
        
        // Then
        XCTAssertTrue(mockGeofenceEventHandler.handleGeofenceEventCalled)
        XCTAssertEqual(mockGeofenceEventHandler.lastLocationName, "Test Location")
        XCTAssertEqual(mockGeofenceEventHandler.lastEventType, .exit)
    }
    
    func testStartMonitoringForRegion() async {
        // Given
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0), radius: 100.0, identifier: "Test Location")
        
        // When
        await locationManagerService.configureGeofences(locations: [GSLocationEntity(name: "Test Location", coordinate: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0))], radius: 100.0)
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didStartMonitoringForRegion)
    }
}
