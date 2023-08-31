//
//  TrackerActivityType.swift
//  Tracker
//
//  Created by Omar Brugna on 28/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreMotion

public enum TrackerActivityType: CaseIterable {
    
    case UNDEFINED
    case STATIONARY
    case WALKING
    case RUNNING
    case CYCLING
    case OTHER
    case AUTOMOTIVE
    case REMOVED
    
    public var id: Int {
        switch self {
            case .UNDEFINED: return 99
            case .STATIONARY: return 3
            case .WALKING: return 7
            case .RUNNING: return 8
            case .CYCLING: return 1
            case .OTHER: return 4
            case .AUTOMOTIVE: return 0
            case .REMOVED: return 98
        }
    }
    
    public static func getById(_ id: Int?) -> TrackerActivityType {
        guard id != nil else { return UNDEFINED }
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        TrackerLogger.e("Transport type not found for id \(id!)")
        return UNDEFINED
    }
    
    public static func getByActivity(_ activity: CMMotionActivity) -> TrackerActivityType {
        if activity.walking == true {
            return TrackerActivityType.WALKING
        } else if activity.running == true {
            return TrackerActivityType.RUNNING
        } else if activity.cycling == true {
            return TrackerActivityType.CYCLING
        } else if activity.automotive == true {
            return TrackerActivityType.AUTOMOTIVE
        } else if activity.stationary == true {
            return TrackerActivityType.STATIONARY
        } else {
            return TrackerActivityType.OTHER
        }
    }
}
