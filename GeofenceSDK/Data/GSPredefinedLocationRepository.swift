//
//  GSPredefinedLocationRepository.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import CoreLocation

/// A concrete repository holding 5 fixed locations
final class GSPredefinedLocationRepository: GSLocationRepositoryProtocol {
    
    private let defaultRadius = 100.0
    
    private let locations: [GSLocationEntity] = [
        GSLocationEntity(name: "İTÜ Ayazağa Kampüsü", coordinate: CLLocationCoordinate2D(latitude: 41.10586458152544, longitude: 29.026283750485295)),
        GSLocationEntity(name: "İTÜ Taşkışla Kampüsü", coordinate: CLLocationCoordinate2D(latitude: 41.04135317110918, longitude: 28.989562367055512)),
        GSLocationEntity(name: "İTÜ Gümüşsuyu Kampüsü", coordinate: CLLocationCoordinate2D(latitude: 41.03820420989215, longitude: 28.991067630189026)),
        GSLocationEntity(name: "İTÜ Maçka Kampüsü", coordinate: CLLocationCoordinate2D(latitude: 41.04415361061073, longitude: 28.995548942322763)),
        GSLocationEntity(name: "İTÜ Tuzla Kampüsü", coordinate: CLLocationCoordinate2D(latitude: 40.81481225447748, longitude: 29.292240660340585)),
        GSLocationEntity(name: "Evinpark Ada", coordinate: CLLocationCoordinate2D(latitude: 40.936395726274434, longitude: 29.132767084209192))
    ]
    
    func getDefaultRadius() -> Double {
        return defaultRadius
    }
    
    func fetchLocations() async -> [GSLocationEntity] {
        return locations
    }
}
