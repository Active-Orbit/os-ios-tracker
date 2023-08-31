//
//  TrackerLocationManager.swift
//  Tracker
//
//  Created by Omar Brugna on 28/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreLocation

internal class TrackerLocationManager: NSObject {

    internal static let instance = TrackerLocationManager()
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var locationStatusIsFirtsCall = true
    
    internal let permissionLocationAlways = TrackerPermissions(.ACCESS_LOCATION_ALWAYS)
    fileprivate var permissionLocationAlwaysListener: TrackerClosureBool?
    
    internal let permissionLocationWhenInUse = TrackerPermissions(.ACCESS_LOCATION_WHEN_IN_USE)
    fileprivate var permissionLocationWhenInUseListener: TrackerClosureBool?
    
    override init() {
        super.init()
        initialize()
    }
    
    fileprivate func initialize() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
}

extension TrackerLocationManager {
    
    // MARK: tracking methods
    
    internal func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    internal func startLocationTracking(_ restart: Bool = false) {
        guard TrackerPreferences.configuration.locationTrackingEnabled else {
            TrackerLogger.w("Location tracking not started because the configuration is set to false")
            return
        }
        
        if restart { initialize() }
        if hasLocationAuthorizationAlways() {
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.desiredAccuracy = getCurrentAccuracy()
            locationManager.distanceFilter = CLLocationDistance(TrackerConstants.DISTANCE_FILTER)
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.activityType = .other
            locationManager.showsBackgroundLocationIndicator = true
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            TrackerLogger.w("Location tracking not started for missing permission")
        }
    }
    
    fileprivate func getCurrentAccuracy() -> CLLocationAccuracy {
        switch TrackerPreferences.tracking.accuracy {
            case .LOW: return kCLLocationAccuracyHundredMeters
            case .MEDIUM: return kCLLocationAccuracyNearestTenMeters
            case .HIGH: return kCLLocationAccuracyBest
            default: return kCLLocationAccuracyBest
        }
    }
    
    internal func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    fileprivate func onDidUpdateLocations(_ locations: [CLLocation]) {
        var trackerDBLocations = [TrackerDBLocation]()
        for location in locations {
            let trackerDBLocation = TrackerDBLocation(location: location)
            trackerDBLocations.append(trackerDBLocation)
        }
        
        TrackerTableLocations.upsert(trackerDBLocations)
        
        let lastAnalyse = TrackerPreferences.routine.lastAnalyse
        if lastAnalyse == nil || TrackerTimeUtils.getCurrent().minutesFrom(lastAnalyse!) >= TrackerConstants.ANALYSE_FREQUENCY_MINUTES {
            TrackerPreferences.routine.lastAnalyse = TrackerTimeUtils.getCurrent()
            TrackerAnalyser.instance.analyse({
                TrackerSummaryManager.createSummaries()
                TrackerApiManager.refresh()
            })
        }
    }
}

extension TrackerLocationManager {
    
    // MARK: authorization methods
    
    internal func hasLocationAuthorizationAlways() -> Bool {
        return permissionLocationAlways.check()
    }
    
    internal func requestLocationAuthorizationAlways(_ listener: @escaping TrackerClosureBool) {
        if hasLocationAuthorizationAlways() {
            permissionLocationAlwaysListener = nil
            listener(true)
        } else {
            permissionLocationAlwaysListener = listener
            permissionLocationAlways.locationManager = locationManager
            permissionLocationAlways.request(listener: { granted in
                if granted {
                    self.permissionLocationAlwaysListener = nil
                    listener(true)
                } else {
                    self.permissionLocationAlwaysListener = nil
                    listener(false)
                }
            })
        }
    }
    
    internal func hasLocationAuthorizationWhenInUse() -> Bool {
        return permissionLocationWhenInUse.check()
    }
    
    internal func requestLocationAuthorizationWhenInUse(_ listener: @escaping TrackerClosureBool) {
        if hasLocationAuthorizationWhenInUse() {
            permissionLocationWhenInUseListener = nil
            listener(true)
        } else {
            permissionLocationWhenInUseListener = listener
            permissionLocationWhenInUse.locationManager = locationManager
            permissionLocationWhenInUse.request(listener: { granted in
                if granted {
                    self.permissionLocationWhenInUseListener = nil
                    listener(true)
                } else {
                    self.permissionLocationWhenInUseListener = nil
                    listener(false)
                }
            })
        }
    }
    
    fileprivate func onPermissionLocationAlwaysAccepted() {
        TrackerLogger.i("Location permission always accepted")
        permissionLocationAlwaysListener?(true)
        permissionLocationWhenInUseListener?(true)
    }
    
    fileprivate func onPermissionLocationWhenInUseAccepted() {
        TrackerLogger.i("Location permission when in use accepted")
        permissionLocationAlwaysListener?(false)
        permissionLocationWhenInUseListener?(true)
    }
    
    fileprivate func onPermissionLocationNotAccepted() {
        TrackerLogger.w("Location permission not accepted")
        permissionLocationAlwaysListener?(false)
        permissionLocationWhenInUseListener?(false)
    }
}

extension TrackerLocationManager: CLLocationManagerDelegate {

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue(label: "locations-updated").sync {
            self.onDidUpdateLocations(locations)
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if locationStatusIsFirtsCall {
            // this method is called automatically when the location manager is initialized
            // we want to skip this case
            locationStatusIsFirtsCall = false
            return
        }
        
        if status == .authorizedAlways {
            onPermissionLocationAlwaysAccepted()
        } else if status == .authorizedWhenInUse {
            onPermissionLocationWhenInUseAccepted()
        } else {
            onPermissionLocationNotAccepted()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        TrackerLogger.w("Location manager error \(error.localizedDescription)")
    }
}
