# GeofenceSDK Documentation

![Alt Text](https://s13.gifyu.com/images/b22Tl.gif)

## Overview

GeoSDK is a framework designed to provide geofence monitoring for iOS applications. It helps developers manage geofence regions, monitor device movement relative to predefined locations, and handle events like entering or exiting geofences. The SDK integrates with the system's location services and notifications.

## Features

* Request location permissions for both foreground and background access.
* Configure and monitor multiple geofences.
* Handle location authorization changes.
* Start and stop geofencing and location monitoring.
* Integrates with custom event handler protocols to handle geofence entry/exit events.
* Provides background location updates for accurate geofencing behavior.
* Supports asynchronous methods for smooth user experience.

## Architecture

The framework is organized into the following components:

### GSLocationManagerService Protocol

The protocol defines the required methods for managing location permissions and geofences. It is designed to be implemented by location manager services to manage location-based features.

#### Methods:

* requestAuthorizations() async -> Bool: Requests location authorization and returns a boolean indicating whether authorization is granted.
* configureGeofences(locations: [GSLocationEntity], radius: Double) async: Configures geofences based on the provided locations and radius.
* stopMonitoring(): Stops monitoring for all active geofences.

``` Swift
protocol GSLocationManagerProtocol {
    func requestAuthorizations() async -> Bool
    func configureGeofences(locations: [GSLocationEntity], radius: Double) async
    func stopMonitoring()
}
``` 

### GSEventHandlerProtocol

GSEventHandlerProtocol defines the methods used for handling geofence entry/exit events. Custom event handlers can implement this protocol to handle these events based on the application's specific requirements.

#### Methods:

* handleGeofenceEvent(locationName: String, eventType: GSEventType): Handles geofence events, such as when a user enters or exits a geofence region.
``` Swift
protocol GSEventHandlerProtocol {
    func handleGeofenceEvent(locationName: String, eventType: GSEventType)
}
``` 
### GSLocationRepositoryProtocol

This protocol defines the methods required to fetch location data and manage predefined geofences.

#### Methods:

* fetchLocations(): Fetches a list of predefined location entities asynchronously.
* getDefaultRadius(): Returns the default radius for region monitoring.
 
``` Swift
protocol GSLocationRepositoryProtocol {
    func fetchLocations() async throws -> [GSLocationEntity]
    func getDefaultRadius() -> Double
}
``` 

### GSMonitoringUseCase

This protocol defines the geofence monitoring use cases: starting and stopping the monitoring process.

#### Methods:

* startMonitoring(): Starts monitoring geofences asynchronously.
* stopMonitoring(): Stops monitoring geofences.

``` Swift
protocol GSMonitoringUseCase {
    func startMonitoring() async
    func stopMonitoring()
}
``` 

### GSPredefinedLocationRepository

An implementation of GSLocationRepositoryProtocol that returns a hardcoded set of predefined locations for geofence monitoring. It also specifies the default radius used for region monitoring.

#### Properties:

* locations: A list of predefined geofence locations.
* defaultRadius: A constant radius value (100 meters by default).

#### Methods:

* getDefaultRadius(): Returns the predefined default radius.
* fetchLocations(): Fetches the predefined locations.
 
### GSMonitoringInteractor

This class implements the GSMonitoringUseCase protocol. It handles the actual start and stop processes of geofence monitoring and uses the GSLocationRepositoryProtocol to fetch locations and the GSLocationManagerProtocol to handle location-based services.

#### Methods:

* startMonitoring(): Fetches locations and configures geofences.
* stopMonitoring(): Stops geofence monitoring.

### GSLocationManagerService

GSLocationManagerService is the core service responsible for managing location-based events, including requesting location authorization and configuring geofences.

#### Responsibilities:

* Request location authorization for foreground and background access.
* Configure geofences based on provided locations and radius.
* Monitor geofence entry/exit events.
* Start/stop location updates and geofencing monitoring.

### DebugLogger

This utility class is used for logging debug messages, including class names, which is helpful during development.

#### Methods:

* debugPrint(): Prints debug messages to the console in debug builds.

### GeoGeofenceSDKDelegate

This protocol defines the delegate methods for handling geofence events such as entering or exiting a geofence region.

#### Methods:

* geofenceSdk(_:didEnterGeofenceWithIdentifier:): Called when a device enters a geofence region.
* geofenceSdk(_:didExitGeofenceWithIdentifier:): Called when a device exits a geofence region.

``` Swift
public protocol GeoGeofenceSDKDelegate: AnyObject {
    func geofenceSdk(_ sdk: GeoSDK, didEnterGeofenceWithIdentifier identifier: String)
    func geofenceSdk(_ sdk: GeoSDK, didExitGeofenceWithIdentifier identifier: String)
}
``` 

### GeoSDK

The core singleton class that manages geofence monitoring. It communicates with the GSMonitoringInteractor to start and stop monitoring geofences.

#### Methods:

* startGeofenceMonitoring(): Starts monitoring geofences.
* stopGeofenceMonitoring(): Stops monitoring geofences.
* registerForNotificationTaps(): Registers the SDK to handle geofence notifications.
 

### User Notification Handling

The SDK also integrates with iOS user notifications. When a geofence event occurs, a notification is delivered, and interactions are handled by GeoSDK.


## Usage Example

### Initializing and Starting Monitoring:

``` Swift
GeoSDK.shared.delegate = self
await GeoSDK.shared.startGeofenceMonitoring()
``` 

### Handling Geofence Events:

``` Swift
extension YourClass: GeoGeofenceSDKDelegate {
    func geofenceSdk(_ sdk: GeoSDK, didEnterGeofenceWithIdentifier identifier: String) {
        print("Entered geofence: \(identifier)")
    }
    
    func geofenceSdk(_ sdk: GeoSDK, didExitGeofenceWithIdentifier identifier: String) {
        print("Exited geofence: \(identifier)")
    }
}
``` 

## Conclusion

This SDK simplifies geofence management by providing easy-to-use methods for monitoring, handling events, and delivering notifications. It supports predefined locations and configurable radius for geofences. You can integrate this SDK into any iOS application that requires geofencing capabilities with minimal setup.
