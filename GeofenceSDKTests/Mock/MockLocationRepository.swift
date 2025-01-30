//
//  MockLocationRepository.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//
@testable import GeofenceSDK

class MockLocationRepository: GSLocationRepositoryProtocol {
    var fetchLocationsResult: Result<[GSLocationEntity], Error>!
    
    func fetchLocations() async throws -> [GSLocationEntity] {
        switch fetchLocationsResult {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        case .none:
            return []
        }
    }
    
    func getDefaultRadius() -> Double {
        return 100.0 // Example radius
    }
}
