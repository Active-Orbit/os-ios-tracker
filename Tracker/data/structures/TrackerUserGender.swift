//
//  TrackerUserGender.swift
//  Tracker
//
//  Created by Omar Brugna on 01/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum TrackerUserGender: CaseIterable {
    
    case UNDEFINED
    case MALE
    case FEMALE
    case OTHER
    case PREFER_NOT_SAY
    
    public var id: Int {
        switch self {
            case .UNDEFINED: return 99
            case .MALE: return 0
            case .FEMALE: return 1
            case .OTHER: return 2
            case .PREFER_NOT_SAY: return 3
        }
    }
    
    public var spinnerPosition: Int {
        switch self {
            case .UNDEFINED: return 0
            case .MALE: return 1
            case .FEMALE: return 2
            case .OTHER: return 3
            case .PREFER_NOT_SAY: return 4
        }
    }
    
    public static func getById(_ id: Int?) -> TrackerUserGender {
        guard id != nil else { return UNDEFINED }
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        TrackerLogger.e("User gender not found for id \(id!)")
        return UNDEFINED
    }
    
    public static func getBySpinnerPosition(_ spinnerPosition: Int?) -> TrackerUserGender {
        guard spinnerPosition != nil else { return UNDEFINED }
        for item in allCases {
            if item.spinnerPosition == spinnerPosition {
                return item
            }
        }
        TrackerLogger.e("User gender not found for spinner position \(spinnerPosition!)")
        return UNDEFINED
    }
}
