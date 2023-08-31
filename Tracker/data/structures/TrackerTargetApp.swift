//
//  TrackerTargetApp.swift
//  Tracker
//
//  Created by Omar Brugna on 06/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum TrackerTargetApp: CaseIterable {
    
    case OTHER
    case S4S
    case SETA
    case AEQORA
    case SKATEBOARD
    case CORONA
    case ACTIVE_ORBIT
    case MOVING_HEALTH
    
    public var id: Int {
        switch self {
            case .OTHER: return 0
            case .S4S: return 1
            case .SETA: return 3
            case .AEQORA: return 4
            case .SKATEBOARD: return 5
            case .CORONA: return 6
            case .ACTIVE_ORBIT: return 7
            case .MOVING_HEALTH: return 8
        }
    }
    
    public static func getById(_ id: Int?) -> TrackerTargetApp {
        guard id != nil else { return OTHER }
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        TrackerLogger.e("Target app not found for id \(id!)")
        return OTHER
    }
}
