//
//  TrackerApiManager.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerApiManager {
    
    internal static func refresh(_ forced: Bool = false) {
        updateUser(forced)
        uploadData(forced)
    }
    
    internal static func registerUser() {
        if TrackerPreferences.configuration.userRegistrationEnabled {
            if TrackerPreferences.configuration.useLegacyUserRegistration {
                TrackerUserEngineLegacy.registerUser()
            } else {
                TrackerUserEngine.registerUser()
            }
        }
    }
    
    public static func updateUser(_ forced: Bool = false) {
        if TrackerPreferences.configuration.userRegistrationEnabled {
            if TrackerPreferences.configuration.useLegacyUserRegistration {
                TrackerUserEngineLegacy.updateUser(forced)
            }
        }
    }
    
    public static func updateUserPushToken() {
        if TrackerPreferences.configuration.userRegistrationEnabled {
            if TrackerPreferences.configuration.useLegacyUserRegistration {
                TrackerUserEngineLegacy.updateUserPushToken()
            }
        }
    }
    
    internal static func uploadData(_ forced: Bool = false) {
        if TrackerPreferences.configuration.dataUploadEnabled {
            TrackerUploadDataEngine.uploadData(forced)
        }
    }
}
