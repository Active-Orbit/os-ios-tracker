//
//  TrackerUserPreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerUserPreferences : TrackerBasePreferences {
    
    public internal(set) var id: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_user_id)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_id) ?? TrackerConstants.EMPTY) as? String
        }
    }
    
    public var pushToken: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_user_push_token)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_push_token) ?? TrackerConstants.EMPTY) as? String
        }
    }
    
    public var name: String? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_user_name)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_name) ?? TrackerConstants.EMPTY) as? String
        }
    }
    
    public var gender: TrackerUserGender {
        set {
            defaultsStandard.setValue(newValue.id, forKey: TrackerPreferencesKeys.preference_user_gender)
        }
        get {
            return TrackerUserGender.getById(defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_gender) as? Int)
        }
    }
    
    public var age: Int? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_user_age)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_age) as? Int
        }
    }
    
    public var ageRange: TrackerUserAgeRange {
        set {
            defaultsStandard.setValue(newValue.id, forKey: TrackerPreferencesKeys.preference_user_age_range)
        }
        get {
            return TrackerUserAgeRange.getById(defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_age_range) as? Int)
        }
    }
    
    public var weight: Int? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_user_weight)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_weight) as? Int
        }
    }
    
    
    public var height: Int? {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_user_height)
        }
        get {
            return defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_user_height) as? Int
        }
    }
    
    internal func logout() {
        id = nil
        // pushToken = nil
        name = nil
        gender = .UNDEFINED
        age = nil
        ageRange = .UNDEFINED
        weight = nil
        height = nil
    }
}
