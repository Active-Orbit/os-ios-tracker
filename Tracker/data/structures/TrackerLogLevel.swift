//
//  TrackerLogLevel.swift
//  Tracker
//
//  Created by Omar Brugna on 14/05/21.
//  Copyright © 2021 Active Orbit. All rights reserved.
//

import Foundation

public enum TrackerLogLevel: CaseIterable {
    
    case LOW
    case MEDIUM
    case HIGH
    
    public var id: Int {
        switch self {
            case .LOW: return 0
            case .MEDIUM: return 1
            case .HIGH: return 2
        }
    }
    
    public static func getDefault() -> TrackerLogLevel {
        return HIGH
    }
    
    public static func getById(_ id: Int?) -> TrackerLogLevel {
        guard id != nil else { return getDefault() }
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        TrackerLogger.e("Log level not found for id \(id!)")
        return getDefault()
    }
}
