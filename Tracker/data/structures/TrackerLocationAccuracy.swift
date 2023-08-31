//
//  TrackerLocationAccuracy.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum TrackerLocationAccuracy: CaseIterable {
    
    case UNDEFINED
    case LOW
    case MEDIUM
    case HIGH
    
    public var id: Int {
        switch self {
            case .UNDEFINED: return 99
            case .LOW: return 0
            case .MEDIUM: return 1
            case .HIGH: return 2
        }
    }
    
    public static func getById(_ id: Int?) -> TrackerLocationAccuracy {
        guard id != nil else { return UNDEFINED }
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        TrackerLogger.e("Location accuracy not found for id \(id!)")
        return UNDEFINED
    }
}
