//
//  TrackerOptionsPreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 16/11/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerOptionsPreferences : TrackerBasePreferences {
    
    public var uploadDataAgreed: Bool {
        set {
            defaultsStandard.setValue(newValue, forKey: TrackerPreferencesKeys.preference_options_upload_data_agreed)
        }
        get {
            return (defaultsStandard.value(forKey: TrackerPreferencesKeys.preference_options_upload_data_agreed) ?? false) as! Bool
        }
    }
    
    internal func logout() {
        uploadDataAgreed = false
    }
}
