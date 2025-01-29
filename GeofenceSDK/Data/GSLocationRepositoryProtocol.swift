//
//  GSLocationRepositoryProtocol.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

protocol GSLocationRepositoryProtocol {
    /// Returns an array of predefined or retrieved location entities.
    func fetchLocations() -> [GSLocationEntity]
}
