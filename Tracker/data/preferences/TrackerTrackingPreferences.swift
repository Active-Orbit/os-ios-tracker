//
//  TrackerTrackingPreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerTrackingPreferences : TrackerBasePreferences {
    
    public var trackingEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_tracking_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_tracking_enabled) ?? true) as! Bool
        }
    }
    
    public var accuracy: TrackerLocationAccuracy {
        set {
            defaultsStandard.setValue(newValue.id, forKey: TrackerPreferencesKeys.preference_tracking_location_accuracy)
        }
        get {
            return TrackerLocationAccuracy.getById(defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_tracking_location_accuracy) as? Int)
        }
    }
    
    internal func logout() {
        trackingEnabled = true
        accuracy = .UNDEFINED
    }
}
