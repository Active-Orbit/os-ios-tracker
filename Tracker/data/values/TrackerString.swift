//
//  TrackerString.swift
//  Tracker
//
//  Created by Omar Brugna on 23/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerString {
    
    public static let TABLE_DEFAULT = "Localizable"
    
    public static func get(_ key: String, bundle: Bundle = TrackerBundle.application, tableName: String = TABLE_DEFAULT) -> String {
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: TrackerConstants.EMPTY, comment: TrackerConstants.EMPTY)
    }
}
