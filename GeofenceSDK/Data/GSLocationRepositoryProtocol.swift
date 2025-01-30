//
//  GSLocationRepositoryProtocol.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

protocol GSLocationRepositoryProtocol {
    /// Asynchronously fetches predefined or retrieved location entities.
    func fetchLocations() async throws -> [GSLocationEntity]
    
    /// Returns predefined radius for region monitoring.
    func getDefaultRadius() -> Double
}
