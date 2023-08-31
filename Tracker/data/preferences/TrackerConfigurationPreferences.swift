//
//  TrackerConfigurationsPreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 25/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerConfigurationsPreferences : TrackerBasePreferences {
    
    internal func configureWith(_ config: TrackerConfig) {
        if config.logLevel != nil { logLevel = config.logLevel! }
        if config.stepsPerSecondThreshold != nil { stepsPerSecondThreshold = config.stepsPerSecondThreshold! }
        if config.stepsPerBriskMinuteThreshold != nil { stepsPerBriskMinuteThreshold = config.stepsPerBriskMinuteThreshold! }
        if config.minimumSegmentDuration != nil {  minimumSegmentDuration = config.minimumSegmentDuration! }
        locationTrackingEnabled = config.locationTrackingEnabled
        intensityEnabled = config.intensityEnabled
        stepsEnabled = config.stepsEnabled
        cyclingEnabled = config.cyclingEnabled
        automotiveEnabled = config.automotiveEnabled
        wifyAnalysisEnabled = config.wifyAnalysisEnabled
        dataUploadEnabled = config.dataUploadEnabled
        useLegacyDataUpload = config.useLegacyDataUpload
        userRegistrationEnabled = config.userRegistrationEnabled
        useLegacyUserRegistration = config.useLegacyUserRegistration
    }
    
    internal var logLevel: TrackerLogLevel {
        set {
            defaultsStandard.setValue(newValue.id, forKey: TrackerPreferencesKeys.preference_configuration_log_level)
        }
        get {
            return TrackerLogLevel.getById(defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_log_level) as? Int)
        }
    }
    
    internal var stepsPerSecondThreshold: Double {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_steps_per_second_threshold)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_steps_per_second_threshold) ?? TrackerConstants.STEPS_PER_SECOND_THRESHOLD) as! Double
        }
    }
    
    internal var stepsPerBriskMinuteThreshold: Double {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_steps_per_brisk_minute_threshold)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_steps_per_brisk_minute_threshold) ?? TrackerConstants.STEPS_PER_BRISK_MINUTE_THRESHOLD) as! Double
        }
    }
    
    internal var minimumSegmentDuration: Int {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_minimum_segment_duration)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_minimum_segment_duration) ?? TrackerConstants.MINIMUM_SEGMENT_DURATION) as! Int
        }
    }
    
    internal var locationTrackingEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_location_tracking_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_location_tracking_enabled) ?? true) as! Bool
        }
    }
    
    internal var intensityEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_intensity_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_intensity_enabled) ?? true) as! Bool
        }
    }
    
    internal var stepsEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_steps_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_steps_enabled) ?? true) as! Bool
        }
    }
    
    internal var cyclingEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_cycling_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_cycling_enabled) ?? true) as! Bool
        }
    }
    
    internal var automotiveEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_automotive_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_automotive_enabled) ?? true) as! Bool
        }
    }
    
    internal var wifyAnalysisEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_wify_analysis_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_wify_analysis_enabled) ?? true) as! Bool
        }
    }
    
    internal var dataUploadEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_data_upload_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_data_upload_enabled) ?? true) as! Bool
        }
    }
    
    internal var useLegacyDataUpload: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_use_legacy_data_upload)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_use_legacy_data_upload) ?? true) as! Bool
        }
    }
    
    internal var userRegistrationEnabled: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_user_registration_enabled)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_user_registration_enabled) ?? true) as! Bool
        }
    }
    
    internal var useLegacyUserRegistration: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_configuration_use_legacy_user_registration)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_configuration_use_legacy_user_registration) ?? true) as! Bool
        }
    }
    
    internal func logout() {
        stepsPerSecondThreshold = TrackerConstants.STEPS_PER_SECOND_THRESHOLD
        stepsPerBriskMinuteThreshold = TrackerConstants.STEPS_PER_BRISK_MINUTE_THRESHOLD
        minimumSegmentDuration = TrackerConstants.MINIMUM_SEGMENT_DURATION
        locationTrackingEnabled = true
        intensityEnabled = true
        stepsEnabled = true
        cyclingEnabled = true
        automotiveEnabled = true
        wifyAnalysisEnabled = true
        dataUploadEnabled = true
        useLegacyDataUpload = false
        userRegistrationEnabled = false
        useLegacyUserRegistration = false
    }
}
