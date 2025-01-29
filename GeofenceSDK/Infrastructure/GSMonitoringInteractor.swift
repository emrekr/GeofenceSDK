//
//  GSMonitoringInteractor.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

final class GSMonitoringInteractor: GSMonitoringUseCase {
    
    private let locationRepo: GSLocationRepositoryProtocol
    private let locationManagerService: GSLocationManagerService
    
    init(locationRepo: GSLocationRepositoryProtocol, locationManagerService: GSLocationManagerService) {
        self.locationRepo = locationRepo
        self.locationManagerService = locationManagerService
    }
    
    func startMonitoring() {
        // Request relevant permissions
        locationManagerService.requestAuthorizations()
        
        // Fetch locations from repository
        let locations = locationRepo.fetchLocations()
        let radius = locationRepo.getRadius()
        
        // Setup geofences
        locationManagerService.configureGeofences(locations: locations, radius: radius)
    }
}
