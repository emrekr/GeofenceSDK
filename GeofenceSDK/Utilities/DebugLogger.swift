//
//  DebugPrinter.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import Foundation

final class DebugLogger {
    
    /// Prints a debug message to the console (in Debug builds) along with the caller's class name.
    ///
    /// - Parameters:
    ///   - message: The message to be printed.
    ///   - object: The object (often `self`) from which the call is made, so we can derive the class.
    static func debugPrint(_ message: String, from object: Any) {
        #if DEBUG
        let className = String(describing: type(of: object))
        NSLog("Geofence SDK DEBUG [%@]: %@", className, message)
        #endif
    }
}
