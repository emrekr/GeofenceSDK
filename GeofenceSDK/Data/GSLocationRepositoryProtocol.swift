//
//  GSLocationRepositoryProtocol.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

protocol GSLocationRepositoryProtocol {
    /// Fetches predefined or retrieved location entities asynchronously.
    func fetchLocations() async -> [GSLocationEntity]
    
    /// Returns predefined radius for region monitoring.
    func getDefaultRadius() -> Double
}
