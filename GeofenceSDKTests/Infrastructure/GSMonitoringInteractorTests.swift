//
//  GSMonitoringInteractorTests.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

import XCTest
@testable import GeofenceSDK
import CoreLocation

class GSMonitoringInteractorTests: XCTestCase {
    
    var interactor: GSMonitoringInteractor!
    var mockLocationRepo: MockLocationRepository!
    var mockLocationManagerService: MockLocationManagerService!
    
    override func setUp() {
        super.setUp()
        mockLocationRepo = MockLocationRepository()
        mockLocationManagerService = MockLocationManagerService()
        interactor = GSMonitoringInteractor(locationRepo: mockLocationRepo, locationManagerService: mockLocationManagerService)
    }
    
    func testStartMonitoring_authorized() async {
        // Given
        mockLocationManagerService.isAuthorized = true
        mockLocationRepo.fetchLocationsResult = .success([GSLocationEntity(name: "Test Location", coordinate: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0))])
        
        // When
        await interactor.startMonitoring()
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didRequestAuthorizations)
        XCTAssertTrue(mockLocationManagerService.didConfigureGeofences)
    }
    
    func testStartMonitoring_notAuthorized() async {
        // Given
        mockLocationManagerService.isAuthorized = false
        
        // When
        await interactor.startMonitoring()
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didRequestAuthorizations)
        XCTAssertFalse(mockLocationManagerService.didConfigureGeofences)
    }
    
    func testStopMonitoring() {
        // When
        interactor.stopMonitoring()
        
        // Then
        XCTAssertTrue(mockLocationManagerService.didStopMonitoring)
    }
}
