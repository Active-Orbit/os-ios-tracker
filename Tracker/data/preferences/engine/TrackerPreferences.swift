//
//  TrackerPreferences.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerPreferences {
    
    internal static let backend = TrackerBackendPreferences()
    internal static let configuration = TrackerConfigurationsPreferences()
    public static let options = TrackerOptionsPreferences()
    public static let routine = TrackerRoutinePreferences()
    public static let tracking = TrackerTrackingPreferences()
    public static let user = TrackerUserPreferences()
}
