//
//  TrackerUserAgeRange.swift
//  Tracker
//
//  Created by Omar Brugna on 01/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public enum TrackerUserAgeRange: CaseIterable {
    
    case UNDEFINED
    case LESS_THAN_18
    case RANGE_1824
    case RANGE_2534
    case RANGE_3544
    case RANGE_4554
    case RANGE_5564
    case MORE_THAN_65
    case PREFER_NOT_SAY
    
    public var id: Int {
        switch self {
            case .UNDEFINED: return 99
            case .LESS_THAN_18: return 0
            case .RANGE_1824: return 1
            case .RANGE_2534: return 2
            case .RANGE_3544: return 3
            case .RANGE_4554: return 4
            case .RANGE_5564: return 5
            case .MORE_THAN_65: return 6
            case .PREFER_NOT_SAY: return 7
        }
    }
    
    public var spinnerPosition: Int {
        switch self {
            case .UNDEFINED: return 0
            case .LESS_THAN_18: return 1
            case .RANGE_1824: return 2
            case .RANGE_2534: return 3
            case .RANGE_3544: return 4
            case .RANGE_4554: return 5
            case .RANGE_5564: return 6
            case .MORE_THAN_65: return 7
            case .PREFER_NOT_SAY: return 8
        }
    }
    
    public static func getById(_ id: Int?) -> TrackerUserAgeRange {
        guard id != nil else { return UNDEFINED }
        for item in allCases {
            if item.id == id {
                return item
            }
        }
        TrackerLogger.e("User age range not found for id \(id!)")
        return UNDEFINED
    }
    
    public static func getBySpinnerPosition(_ spinnerPosition: Int?) -> TrackerUserAgeRange {
        guard spinnerPosition != nil else { return UNDEFINED }
        for item in allCases {
            if item.spinnerPosition == spinnerPosition {
                return item
            }
        }
        TrackerLogger.e("User age range not found for spinner position \(spinnerPosition!)")
        return UNDEFINED
    }
}
