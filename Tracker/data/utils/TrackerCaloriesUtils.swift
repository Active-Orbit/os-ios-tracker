//
//  TrackerCaloriesUtils.swift
//  Tracker
//
//  Created by Omar Brugna on 17/12/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Utility class that provides some useful methods to manage calories
 */
public class TrackerCaloriesUtils {
    
    fileprivate static var netCalories = false
    
    public static func getCaloriesFor(_ segment: TrackerDBSegment) -> Double? {
        
        let userWeight = TrackerPreferences.user.weight
        let userHeight = TrackerPreferences.user.height
        let userAge = TrackerPreferences.user.age
        let userGender = TrackerPreferences.user.gender
        
        if userWeight == nil || userHeight == nil || userAge == nil || userGender == .UNDEFINED {
            TrackerLogger.w("Cannot compute calories for missing user details")
            return nil
        }
        
        let weightInPounds = Double(userWeight!) * 2.2046226
        
        let multiplier = userGender == .FEMALE ? 0.413 : 0.415
        let stepLengthCentimeters = Double(userHeight!) * multiplier
        let distanceMeters = Double(segment.steps) * stepLengthCentimeters / 100.0
        let distanceMiles = TrackerDistanceUtils.metersToMiles(distanceMeters)
        
        let speed = calculateSpeedMPH(segment, stepLengthCentimeters)
        let intensity = getIntensityRate(speed)
        
        return Double(weightInPounds) * intensity * distanceMiles
    }
    
    fileprivate static func calculateSpeedMPH(_ segment: TrackerDBSegment, _ stepLengthCentimeters: Double) -> Double {
        let centimeters = Double(segment.steps) * stepLengthCentimeters
        let duration = segment.getDuration()
        let centimetersPerSecond = centimeters / Double(duration)
        let mphMultiplier = 0.0223694
        return centimetersPerSecond * mphMultiplier
    }
    
    fileprivate static func getIntensityRate(_ speedMPH: Double) -> Double {
        var intensityRate = 0.0
        let walkingRate = netCalories ? 0.30 : 0.53
        let runningRate = netCalories ? 0.63 : 0.75
        if speedMPH > 1 && speedMPH < 4 {
            intensityRate = walkingRate
        }
        if speedMPH >= 4 && speedMPH < 30 {
            intensityRate = runningRate
        }
        return intensityRate
    }
}
