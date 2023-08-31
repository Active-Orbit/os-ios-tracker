//
//  TrackerBackendPreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerBackendPreferences : TrackerBasePreferences {
    
    internal var baseUrl: String {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_backend_base_url)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_backend_base_url) ?? TrackerConstants.EMPTY) as! String
        }
    }
    
    public var targetApp: TrackerTargetApp {
        set {
            defaultsStandard.setValue(newValue.id, forKey: TrackerPreferencesKeys.preference_backend_target_app)
        }
        get {
            return TrackerTargetApp.getById(defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_backend_target_app) as? Int)
        }
    }
    
    internal func logout() {
        // baseUrl = TrackerConstants.EMPTY
        // targetApp = .OTHER
    }
}
