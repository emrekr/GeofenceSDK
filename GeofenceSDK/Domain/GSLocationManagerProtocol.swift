//
//  GSLocationManagerProtocol.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 30.01.2025.
//

protocol GSLocationManagerProtocol {
    func requestAuthorizations() async -> Bool
    func configureGeofences(locations: [GSLocationEntity], radius: Double) async
    func stopMonitoring()
}
