//
//  TrackerDistanceUtils.swift
//  Tracker
//
//  Created by Omar Brugna on 17/12/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Utility class that provides some useful methods to manage distances
 */
public class TrackerDistanceUtils {
    
    public static func metersToMiles(_ meters: Double, _ decimals: Int? = nil) -> Double {
        let result = meters * 0.000621371192
        if decimals != nil { return result.roundTo(decimals!) }
        return result
    }
    
    public static func milesToMeters(_ miles: Double, _ decimals: Int? = nil) -> Double {
        let result =  miles * 1609.344
        if decimals != nil { return result.roundTo(decimals!) }
        return result
    }
    
    public static func metersToKm(_ meters: Double, _ decimals: Int? = nil) -> Double {
        let result =  meters / 1000.0
        if decimals != nil { return result.roundTo(decimals!) }
        return result
    }
    
    public static func kmToMeters(_ km: Double, _ decimals: Int? = nil) -> Double {
        let result =  km * 1000.0
        if decimals != nil { return result.roundTo(decimals!) }
        return result
    }
}
