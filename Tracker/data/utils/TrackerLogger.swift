//
//  TrackerLogger.swift
//  Tracker
//
//  Created by Omar Brugna on 17/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 Utility class to log with tag and colours
 */
public class TrackerLogger {
    
    public static let TAG = "Tracker:"
    public static let LOG_ENABLED = true
    
    public static func d(_ string : String?) {
        d(TAG, string)
    }
    
    public static func i(_ string : String?) {
        i(TAG, string)
    }
    
    public static func w(_ string : String?) {
        w(TAG, string)
    }
    
    public static func e(_ string : String?) {
        e(TAG, string)
    }
    
    public static func o(_ object: Any?) {
        o(TAG, object)
    }
    
    public static func d(_ tag : String, _ string : String?) {
        if LOG_ENABLED {
            print("⚪ \(tag) \(string ?? TrackerConstants.EMPTY)")
        }
    }
    
    public static func i(_ tag : String, _ string : String?) {
        if LOG_ENABLED {
            print("🔵 \(tag) \(string ?? TrackerConstants.EMPTY)")
        }
    }
    
    public static func w(_ tag : String, _ string : String?) {
        if LOG_ENABLED {
            print("🟡 \(tag) \(string ?? TrackerConstants.EMPTY)")
        }
    }
    
    public static func e(_ tag : String, _ string : String?) {
        if LOG_ENABLED {
            print("🔴 \(tag) \(string ?? TrackerConstants.EMPTY)")
        }
    }
    
    public static func o(_ tag : String, _ object: Any?) {
        if LOG_ENABLED {
            if object != nil {
                print("⚫ \(tag) \(object!)")
            } else {
                print("🔴 \(tag) Trying to log a nil object")
            }
        }
    }
}
