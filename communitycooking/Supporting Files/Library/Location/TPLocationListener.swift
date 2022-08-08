//
//  TPLocationListener.swift
//  PluginsForIOSLibrary
//
//  Created by FMA1 on 12.06.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation
import CoreLocation

/**
* Diese Klasse stellt Methoden für das Location Tracking eines Nutzers bereit
*/
public class TPLocationListener: NSObject {
    
    private var distanceInMeters: Double = 1.0
    private var callback: ((_ location: TPLocation) -> Void)? = nil
    
    private let locationManager = CLLocationManager()
    private var isListeningOnce = false
    private var isListening = false
    private var lastKnownPosition: TPLocation? = nil
    
    /**
    Initalisierung eines TPLocationListeners
    - Parameter distanceInMeters: Notwendige Distanz, die überschritten werden muss, bevor Änderungen über den Callback zurückgegeben werden
    - Parameter location: TPLocation-Objekt
    */
    public init(distanceInMeters: Double = 1.0) {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = distanceInMeters
        locationManager.requestAlwaysAuthorization()
        self.distanceInMeters = distanceInMeters
    }
    
    /**
     Setzen einer Callbackfunktion, über die TPLocation-Objekte bei Positionsänderung zurückgegeben werden können
    - Parameter callback: Callbackfunktion, über die ein TPLocation-Objekt zurückgegeben werden kann
     # Reference TPLocation
     */
    public func setCallback(callback: @escaping (_ location: TPLocation) -> Void) {
        self.callback = callback
    }
    
    
    /**
    Bei erteilter Berechtigung wird das Location Listening gestartet und auf Positionsupdates gewartet. Ohne passende Berechtigung wird das Location Listening nicht gestartet und keine Fehlermeldung ausgegeben.
     
    # Reference TPLocation
    */
    public func startListeningForUpdates() {
        if TPLocationListener.hasPermission() && !isListening {
            self.isListening = true
            locationManager.startUpdatingLocation()
        } else if TPLocationListener.hasPermission() {
            if let position = lastKnownPosition {
                if let callback = callback {
                    callback(position)
                }
            }
            isListeningOnce = false
        }
    }

    /**
    Sucht die aktuelle Position und gibt diese über den Callback zurück
     
    # Reference TPLocation
    */
    public func getCurrentLocation() {
        isListeningOnce = true
        startListeningForUpdates()
    }
    
    /**
    * Stoppt alle LocationUpdates
    */
    public func stopListeningForUpdates() {
        isListening = false
        isListeningOnce = false
        locationManager.stopUpdatingLocation()
    }
    
    /**
    Wird aktiv auf Positionänderungen gewartet, gibt diese Funktion `true` zurück,
    es wird auf Änderungen gewartet sobald die Methode `startListeningForUpdates()`
    aufgerufen wurde und nicht durch die Methode `stopListeningForUpdates()` gestoppt wurde
    - Returns: `true` wenn auf Positionsänderungen gewartet wird, ansonsten `false`
    */
    public func isListeningForUpdates() -> Bool {
        return isListening
    }
    
    /**
    Gibt die zuletzt bekannte Position zurück,
    wenn noch keine Position ermittelt wurde, wird `nil` zurückgegeben
    - Returns: TPLocation oder nil
    # Reference TPLocation
    */
    public func getLastKnownLocation() -> TPLocation? {
        return lastKnownPosition
    }
    
    /**
    Prüft ob, die Permission erteilt wurde
    - Returns: `true` wenn die Permissions erteilt wurden, ansonsten `false`
    */
    public static func hasPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                default:
                    return false
            }
        }
        return false
    }
}

/// Erweiterung für TPLocationListener, um Standortänderungen zu Empfangen und zu Verarbeiten
extension TPLocationListener: CLLocationManagerDelegate {
    
    /**
    Diese Methode wird intern verwendet und sollte nicht durch den Entwickler aufgerufen oder überschrieben werden.
    - Parameter manager: CLLocationManager, der für den Empfang der Location-Updates verantwortlich ist
    - Parameter didUpdateLocations: Liste mit Location-Objekten
    # Reference TPLocation
    */
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        lastKnownPosition = TPLocation(time: location.timestamp.timeIntervalSince1970, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude, speed: location.speed, accuracy: location.horizontalAccuracy)
        if let callback = callback {
            callback(lastKnownPosition!)
        }

        if(isListeningOnce) {
            stopListeningForUpdates()
        }
    }
}
