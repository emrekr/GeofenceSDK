//
//  GSMonitoringInteractor.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

final class GSMonitoringInteractor: GSMonitoringUseCase {
    
    private let locationRepo: GSLocationRepositoryProtocol
    private let locationManagerService: GSLocationManagerProtocol
    
    init(locationRepo: GSLocationRepositoryProtocol, locationManagerService: GSLocationManagerProtocol) {
        self.locationRepo = locationRepo
        self.locationManagerService = locationManagerService
    }
    
    func startMonitoring() async {
        // Request relevant permissions asynchronously
        let isAuthorized = await locationManagerService.requestAuthorizations()
        
        if !isAuthorized {
            // Handle the case where authorization failed (show an alert, etc.)
            DebugLogger.debugPrint("Authorization failed or was denied.", from: self)
            return
        }
        
        // Fetch locations asynchronously from the repository
        do {
            let locations = try await locationRepo.fetchLocations()  // Await async call
            let radius = locationRepo.getDefaultRadius()  // Sync call, remains unchanged
            
            // Setup geofences asynchronously
            await locationManagerService.configureGeofences(locations: locations, radius: radius)
            DebugLogger.debugPrint("Geofences successfully configured.", from: self)
        } catch {
            // Handle potential errors in fetching locations
            DebugLogger.debugPrint("Error fetching locations: \(error)", from: self)
        }
    }
    
    func stopMonitoring() {
        locationManagerService.stopMonitoring()
        DebugLogger.debugPrint("Geofence monitoring stopped.", from: self)
    }
}
