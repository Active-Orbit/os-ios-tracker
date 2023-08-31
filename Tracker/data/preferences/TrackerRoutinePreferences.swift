//
//  TrackerRoutinePreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerRoutinePreferences : TrackerBasePreferences {
    
    public var firstInstall: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_routine_first_install)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_routine_first_install) as? Date
        }
    }
    
    internal var lastAnalyse: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_routine_last_analyse)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_routine_last_analyse) as? Date
        }
    }
    
    internal var lastUserUpdate: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_routine_last_user_update)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_routine_last_user_update) as? Date
        }
    }
    
    internal var lastDataUpload: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_routine_last_data_upload)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_routine_last_data_upload) as? Date
        }
    }
    
    internal var lastNotesUpload: Date? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_routine_last_notes_upload)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_routine_last_notes_upload) as? Date
        }
    }
    
    internal func logout() {
        firstInstall = nil
        lastUserUpdate = nil
        lastDataUpload = nil
        lastNotesUpload = nil
    }
}
