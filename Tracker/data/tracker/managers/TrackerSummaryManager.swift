//
//  TrackerSummaryManager.swift
//  Tracker
//
//  Created by Omar Brugna on 14/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreLocation

internal class TrackerSummaryManager {
    
    internal static func createSummaries() {

        var startDate = TrackerTimeUtils.getCurrent().startOfDay
        
        let firstInstallDate = TrackerPreferences.routine.firstInstall
        if firstInstallDate != nil {
            if firstInstallDate!.after(startDate) {
                startDate = firstInstallDate!
            } else {
                startDate = firstInstallDate!.startOfDay
            }
        }
        
        let now = TrackerTimeUtils.getCurrent()
        var endDate = startDate.endOfDay
        
        while endDate.before(now) {
            createSummary(startDate, endDate)
            startDate = startDate.add(component: .day, value: 1)!
            endDate = startDate.endOfDay
        }
    }
    
    fileprivate static func createSummary(_ startDate: Date, _ endDate: Date, _ listener: TrackerClosureVoid? = nil) {
        let segments = TrackerTableSegments.getBetween(startDate, endDate)
        if segments.isEmpty {
            TrackerLogger.d("No summary segments for \(TrackerTimeUtils.log(startDate)) - \(TrackerTimeUtils.log(endDate))")
            DispatchQueue.main.async {
                listener?()
            }
        } else {
            
            for segment in segments {
                segment.addSteps()
                segment.addBrisk()
                segment.addLocations()
            }
            
            let summary = TrackerDBSummary()
            summary.date = startDate
            
            summary.floorsClimbed = TrackerSummaryManager.getFloorsClimbed(segments)
            summary.numberOfSteps = TrackerSummaryManager.getSteps(segments)
            summary.timeWalking = TrackerSummaryManager.getActivityTypeDuration(segments, .WALKING)
            summary.timeRunning = TrackerSummaryManager.getActivityTypeDuration(segments, .RUNNING)
            summary.timeCycling = TrackerSummaryManager.getActivityTypeDuration(segments, .CYCLING)
            summary.timeAutomotive = TrackerSummaryManager.getActivityTypeDuration(segments, .AUTOMOTIVE)
            summary.timeOther = TrackerSummaryManager.getActivityTypeDuration(segments, .OTHER)
            summary.briskWalking = TrackerSummaryManager.getBriskDuration(segments)
            summary.distanceWalking = Int(TrackerSummaryManager.getWalkingDistance(segments, .WALKING))
            summary.distanceRunning = Int(TrackerSummaryManager.getWalkingDistance(segments, .RUNNING))
            summary.distanceCycling = Int(TrackerSummaryManager.getLocationDistance(segments, .CYCLING))
            summary.distanceAutomotive = Int(TrackerSummaryManager.getLocationDistance(segments, .AUTOMOTIVE))
            summary.distanceOther = 0
            summary.weekly = TrackerConstants.FALSE
            
            summary.generateId()
            TrackerTableSummaries.upsert(summary)

            TrackerLogger.d("Summary generated \(summary.description)")
        }
    }
    
    fileprivate static func getActivityTypeDuration(_ segments: [TrackerDBSegment], _ type: TrackerActivityType) -> Int {
        var activityDuration = 0
        for segment in segments {
            if segment.type == type.id {
                activityDuration += segment.activityDuration
            }
        }
        return activityDuration
    }
    
    fileprivate static func getSteps(_ segments: [TrackerDBSegment]) -> Int {
        var steps = 0
        for segment in segments {
            if segment.type == TrackerActivityType.WALKING.id || segment.type == TrackerActivityType.RUNNING.id {
                steps += max(segment.steps, 0)
            }
        }
        return steps
    }
    
    fileprivate static func getFloorsClimbed(_ segments: [TrackerDBSegment]) -> Int {
        var floorsClimbed = 0
        for segment in segments {
            if segment.type == TrackerActivityType.WALKING.id || segment.type == TrackerActivityType.RUNNING.id {
                floorsClimbed += max(segment.floorsClimbed, 0)
            }
        }
        return floorsClimbed
    }
    
    fileprivate static func getBriskDuration(_ segments: [TrackerDBSegment]) -> Int {
        var briskDuration = 0
        for segment in segments {
            briskDuration += max(segment.numberOfBriskChunks, 0)
        }
        return briskDuration
    }
    
    fileprivate static func getWalkingDistance(_ segments: [TrackerDBSegment], _ type: TrackerActivityType) -> Double {
        var totalSteps: Double = 0
        let strideLength = 0.76
        for segment in segments {
            if segment.type == type.id {
                totalSteps += Double(segment.steps)
            }
        }
        return totalSteps / strideLength
    }
    
    fileprivate static func getLocationDistance(_ segments: [TrackerDBSegment], _ type: TrackerActivityType) -> Double {
        var totalDistance: Double = 0
        for segment in segments {
            totalDistance += segment.getDistance([type], false)
        }
        return totalDistance
    }
}
