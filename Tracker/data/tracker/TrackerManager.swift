//
//  TrackerManager.swift
//  Tracker
//
//  Created by Omar Brugna on 08/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

public class TrackerManager {
    
    public static let instance = TrackerManager()
    
    public static var config: TrackerConfig? {
        didSet {
            if config != nil {
                TrackerPreferences.configuration.configureWith(config!)
            } else {
                TrackerLogger.w("Tracker configuration is null, probably an implementation issue")
            }
        }
    }
    
    // MARK: initialize methods
    
    #if os(iOS)
    
    public static func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        if TrackerPreferences.routine.firstInstall == nil {
            // remember first installation date
            TrackerPreferences.routine.firstInstall = TrackerTimeUtils.getCurrent()
        }
        
        if TrackerLocaleUtils.isItalianLanguage() {
            TrackerPreferences.backend.baseUrl = TrackerEnvironment.BASE_URL_IT
        } else {
            TrackerPreferences.backend.baseUrl = TrackerEnvironment.BASE_URL
        }
        
        if TrackerTextUtils.isEmpty(TrackerPreferences.user.id) {
            TrackerApiManager.registerUser()
        } else {
            TrackerApiManager.refresh(true)
        }
        
        if TrackerPreferences.configuration.locationTrackingEnabled {
            if launchOptions?.keys.contains(.location) == true {
                // app restarted for a background location event, restart location tracking
                TrackerLocationManager.instance.startLocationTracking(true)
            }
        }
    }
    
    #else
    
    public static func initialize() {
        
        if TrackerPreferences.routine.firstInstall == nil {
            // remember first installation date
            TrackerPreferences.routine.firstInstall = TrackerTimeUtils.getCurrent()
        }
        
        if TrackerLocaleUtils.isItalianLanguage() {
            TrackerPreferences.backend.baseUrl = TrackerEnvironment.BASE_URL_IT
        } else {
            TrackerPreferences.backend.baseUrl = TrackerEnvironment.BASE_URL
        }
    }
    
    #endif
    
    public func refresh(_ fromDate: Date, _ toDate: Date, _ listener: TrackerClosureVoid? = nil) {
        TrackerAnalyser.instance.analyse(fromDate, toDate, {
            TrackerSummaryManager.createSummaries()
            listener?()
        })
    }
    
    fileprivate func checkInitialization() {
        if TrackerTextUtils.isEmpty(TrackerPreferences.backend.baseUrl) {
            TrackerException("Tracker not initialized, please call TrackerManager.initialize() on didFinishLaunchingWithOptions method")
        }
    }
    
    public func setTargetApp(_ targetApp: TrackerTargetApp) {
        TrackerPreferences.backend.targetApp = targetApp
    }
    
    public func saveUserRegistrationId(_ userId: String?, overrideFirstInstall: Bool = false) {
        TrackerPreferences.user.id = userId
        
        if overrideFirstInstall {
            // override first installation date
            TrackerPreferences.routine.firstInstall = TrackerTimeUtils.getCurrent()
        }
    }
    
    public func logout() {
        TrackerBasePreferences.logout()
        TrackerDatabase.instance.logout()
    }
}

#if os(iOS)

extension TrackerManager {
    
    // MARK: tracking methods
    
    public func startLocationTracking() {
        checkInitialization()
        TrackerLocationManager.instance.startLocationTracking()
    }
    
    public func stopLocationTracking() {
        checkInitialization()
        TrackerLocationManager.instance.stopLocationTracking()
    }
}

#endif

#if os(iOS)

extension TrackerManager {
    
    // MARK: location methods
    
    public func locationServicesEnabled() -> Bool {
        return TrackerLocationManager.instance.locationServicesEnabled()
    }
    
    public func locationAuthorizationStatus() -> CLAuthorizationStatus {
        checkInitialization()
        return TrackerPermissions.locationAuthorizationStatus()
    }
    
    public func hasLocationAuthorizationAlways() -> Bool {
        checkInitialization()
        return TrackerLocationManager.instance.hasLocationAuthorizationAlways()
    }
    
    public func hasLocationAuthorizationWhenInUse() -> Bool {
        checkInitialization()
        return TrackerLocationManager.instance.hasLocationAuthorizationWhenInUse()
    }
    
    public func requestLocationAuthorizationAlways(_ listener: @escaping TrackerClosureBool) {
        checkInitialization()
        TrackerLocationManager.instance.requestLocationAuthorizationAlways(listener)
    }

    public func requestLocationAuthorizationWhenInUse(_ listener: @escaping TrackerClosureBool) {
        checkInitialization()
        TrackerLocationManager.instance.requestLocationAuthorizationWhenInUse(listener)
    }
}

#endif

extension TrackerManager {
    
    // MARK: motion methods
    
    public func motionActivityAvailable() -> Bool {
        return TrackerMotionManager.instance.motionActivityAvailable()
    }
    
    public func motionAuthorizationStatus() -> CMAuthorizationStatus {
        checkInitialization()
        return TrackerPermissions.motionAuthorizationStatus()
    }
    
    public func hasMotionAuthorization() -> Bool {
        checkInitialization()
        return TrackerMotionManager.instance.hasMotionAuthorization()
    }
    
    public func requestMotionAuthorization(_ listener: @escaping TrackerClosureBool) {
        checkInitialization()
        TrackerMotionManager.instance.requestMotionAuthorization(listener)
    }
}

extension TrackerManager {
    
    // MARK: pedometer methods
    
    public func pedometerEventTrackingAvailable() -> Bool {
        return TrackerPedometerManager.instance.pedometerEventTrackingAvailable()
    }
    
    public func pedometerAuthorizationStatus() -> CMAuthorizationStatus {
        checkInitialization()
        return TrackerPermissions.pedometerAuthorizationStatus()
    }
    
    public func hasPedometerAuthorization() -> Bool {
        checkInitialization()
        return TrackerPedometerManager.instance.hasPedometerAuthorization()
    }
    
    public func requestPedometerAuthorization(_ listener: @escaping TrackerClosureBool) {
        checkInitialization()
        TrackerPedometerManager.instance.requestPedometerAuthorization(listener)
    }
}
