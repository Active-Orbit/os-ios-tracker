//
//  TrackerBasePreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerBasePreferences {
    
    public static func logout() {
        TrackerPreferences.backend.logout()
        TrackerPreferences.configuration.logout()
        TrackerPreferences.routine.logout()
        TrackerPreferences.options.logout()
        TrackerPreferences.user.logout()
        TrackerPreferences.tracking.logout()
    }
    
    public static func printAll() {
        TrackerLogger.d("Stored TrackerPreferences")
        for preference in UserDefaults.standard.dictionaryRepresentation() {
            if preference.key.starts(with: "tracker.") {
                TrackerLogger.d("\(preference.key) : \(preference.value)")
            }
        }
    }
}
