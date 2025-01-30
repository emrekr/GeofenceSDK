//
//  MockLocationRepositoryTests.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

import XCTest
import CoreLocation
@testable import GeofenceSDK

class MockLocationRepositoryTests: XCTestCase {
    
    var mockRepository: MockLocationRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockLocationRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchLocations_Success() async {
        // Given
        let expectedLocations = [GSLocationEntity(name: "Location 1", coordinate: CLLocationCoordinate2D(latitude: 40.0, longitude: 29.0))]
        mockRepository.fetchLocationsResult = .success(expectedLocations)
        
        // When
        do {
            let locations = try await mockRepository.fetchLocations()
            
            // Then
            XCTAssertEqual(locations.count, 1)
            XCTAssertEqual(locations.first?.name, "Location 1")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testFetchLocations_Failure() async {
        // Given
        mockRepository.fetchLocationsResult = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))
        
        // When
        do {
            _ = try await mockRepository.fetchLocations()
            XCTFail("Expected error, but got success")
        } catch {
            // Then
            XCTAssertTrue(error is NSError)
        }
    }
}
