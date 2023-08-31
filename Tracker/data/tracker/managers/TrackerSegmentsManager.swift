//
//  TrackerSegmentsManager.swift
//  Tracker
//
//  Created by Omar Brugna on 04/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerSegmentsManager {
    
    internal static func create(_ activities: [TrackerDBActivity]) -> [TrackerDBSegment] {
        var segmentsArray = [TrackerDBSegment]()
        var segment: TrackerDBSegment?
        
        var timeIdle = 0
        
        let activities = activities.sorted(by: { $0.startDate?.timeInMillis ?? 0 < $1.startDate?.timeInMillis ?? 0 })
        
        for (index, activity) in activities.enumerated() {
            
            if TrackerPreferences.configuration.logLevel.id >= TrackerLogLevel.HIGH.id {
                TrackerLogger.d("Reading activity: \(activity.description())")
            }
            
            guard activity.startDate != nil && activity.endDate != nil else {
                continue
            }
            
            let startDate = activity.startDate!
            let endDate = activity.endDate!
            let duration = activity.duration()
            let steps = TrackerPedometerManager.instance.getSteps(startDate, endDate)
            let stepsPerSecond = Double(steps) / Double(duration)
            let enoughSteps = stepsPerSecond >= TrackerPreferences.configuration.stepsPerSecondThreshold || activity.activityType == TrackerActivityType.CYCLING.id || activity.activityType == TrackerActivityType.AUTOMOTIVE.id
            
            if enoughSteps {
                if segment == nil {
                    // enough steps, start a new segment
                    segment = TrackerDBSegment()
                    segment!.startDate = activity.startDate
                    segment!.endDate = activity.endDate
                    segment!.type = activity.activityType
                    segment!.activities.append(activity)
                } else {
                    if segment!.sameActivityTypeOf(activity.activityType) {
                        // enough steps and same type, add them to the current segment
                        segment!.endDate = activity.endDate
                        segment!.activities.append(activity)
                    } else {
                        // enough steps but different type, close the segment
                        segment!.addBrisk()
                        segment!.generateId()
                        segmentsArray.append(segment!)
                        segment = nil
                        timeIdle = 0
                        
                        // start a new segment
                        segment = TrackerDBSegment()
                        segment!.startDate = activity.startDate
                        segment!.endDate = activity.endDate
                        segment!.type = activity.activityType
                        segment!.activities.append(activity)
                    }
                }
            } else {
                if segment != nil {
                    // not enough steps, check the idle time
                    if index > 0 {
                        let previousEndDate = activities[index - 1].endDate
                        timeIdle += endDate.secondsFrom(previousEndDate!)
                        if timeIdle >= TrackerConstants.STATIONARY_SECONDS {
                            // enough idle time, close the segment
                            segment!.addBrisk()
                            segment!.generateId()
                            segmentsArray.append(segment!)
                            segment = nil
                            timeIdle = 0
                        } else {
                            // not enough idle time, add the activity to the segment
                            segment!.endDate = activity.endDate
                            segment!.activities.append(activity)
                        }
                    }
                } else {
                    // not enough steps, no segment in progress, do nothing
                }
            }
            
            if index == activities.count - 1 {
                if segment != nil {
                    // last activity, close the segment
                    let currentActivityAdded = !segment!.activities.map({ $0.activityId == activity.activityId }).isEmpty
                    if !currentActivityAdded {
                        segment!.endDate = activity.endDate
                        segment!.activities.append(activity)
                    }
                    segment!.addBrisk()
                    segment!.generateId()
                    segmentsArray.append(segment!)
                    segment = nil
                    timeIdle = 0
                }
            }
        }
        return segmentsArray
    }
    
    internal static func getWithoutNoise(_ segments: [TrackerDBSegment]) -> [TrackerDBSegment] {
        var validSegments = [TrackerDBSegment]()
        for segment in segments {
            if !isNoise(segment) {
                validSegments.append(segment)
            }
        }
        return validSegments
    }
    
    fileprivate static func isNoise(_ segment: TrackerDBSegment) -> Bool {
        var numberOfOtherActivities: Double = 0.0
        let numberOfActivities = Double(segment.activities.count)
        for activity in segment.activities {
            if activity.activityType == TrackerActivityType.OTHER.id {
                numberOfOtherActivities += 1
            }
        }
        return numberOfOtherActivities / numberOfActivities > 0.9
    }
    
    internal static func setActivityDurationTo(_ segments: [TrackerDBSegment]) {
        for segment in segments { setActivityDurationTo(segment) }
    }
    
    internal static func setActivityDurationTo(_ segment: TrackerDBSegment) {
        var activityDuration = 0
        for activity in segment.activities {
            activityDuration += activity.duration()
        }
        segment.activityDuration = activityDuration
        
        if TrackerPreferences.configuration.logLevel.id >= TrackerLogLevel.HIGH.id {
            TrackerLogger.d("Setting activity duration \(activityDuration) to \(segment.description())")
        }
    }
    
    internal static func getWithMinimumDuration(_ segments: [TrackerDBSegment], _ duration: Int) -> [TrackerDBSegment] {
        var validSegments = [TrackerDBSegment]()
        for segment in segments {
            if segment.getDuration() >= duration {
                validSegments.append(segment)
            }
        }
        return validSegments
    }
    
    internal static func setBriskChunksTo(_ segments: [TrackerDBSegment]) {
        for segment in segments { setBriskChunksTo(segment) }
    }
    
    internal static func setBriskChunksTo(_ segment: TrackerDBSegment) {
        if segment.activityDuration < TrackerConstants.BRISK_SECONDS_THRESHOLD {
            segment.brisk = TrackerConstants.FALSE
            return
        }
        var brisk = 0
        for activity in segment.activities {
            brisk += getBriskPeriod(activity)
        }
        segment.numberOfBriskChunks = brisk
    }
    
    internal static func getBriskPeriod(_ activity: TrackerDBActivity) -> Int {
        let duration = activity.duration()
        if duration < Int(TrackerConstants.BRISK_CHUNK_LENGTH) {
            return 0
        }
        
        let startDate = activity.startDate!
        
        let chunksTotal = Int(floor(Double(duration) / TrackerConstants.BRISK_CHUNK_LENGTH))
        let chunksForMinute = 60.0 / TrackerConstants.BRISK_CHUNK_LENGTH
        let chunkRequiredSteps = TrackerPreferences.configuration.stepsPerBriskMinuteThreshold / chunksForMinute
        
        var chunksCurrent = 0
        
        var briskMinutes = 0
        var briskWalkingCurrent: TrackerDBBriskWalking?
        
        var pedometers = [TrackerDBPedometer]()
        var briskWalkings = [TrackerDBBriskWalking]()
        
        for chunk in 1...chunksTotal {
            
            let chunkStartTime = startDate.addingTimeInterval(Double(chunk - 1) * TrackerConstants.BRISK_CHUNK_LENGTH)
            let chunkEndTime = startDate.addingTimeInterval(Double(chunk) * TrackerConstants.BRISK_CHUNK_LENGTH)
            
            let chunkSteps = TrackerPedometerManager.instance.getSteps(chunkStartTime, chunkEndTime)
            if Double(chunkSteps) > chunkRequiredSteps {
                chunksCurrent += 1
                if briskWalkingCurrent != nil {
                    // extend the brisk end date
                    briskWalkingCurrent!.endDate = chunkEndTime
                } else {
                    // create a new brisk walking
                    briskWalkingCurrent = TrackerDBBriskWalking()
                    briskWalkingCurrent!.startDate = chunkStartTime
                    briskWalkingCurrent!.endDate = chunkEndTime
                }
            }
            
            if chunksCurrent == Int(chunksForMinute) {
                briskMinutes += 1
                briskWalkings.append(briskWalkingCurrent!)
                
                let (stepsUpToNow, floorsClimbed) = TrackerPedometerManager.instance.getStepsAndFloorsClimbed(briskWalkingCurrent!.endDate!.startOfDay, briskWalkingCurrent!.endDate!)
                
                let pedometer = TrackerDBPedometer()
                pedometer.startDate = briskWalkingCurrent!.endDate?.startOfDay
                pedometer.endDate = briskWalkingCurrent!.endDate
                pedometer.numberOfSteps = stepsUpToNow
                pedometer.floorsClimbed = floorsClimbed
                if pedometer.isValid() == true {
                    pedometer.generateId()
                    pedometers.append(pedometer)
                }
                
                // reset
                chunksCurrent = 0
                briskWalkingCurrent = nil
            }
        }
        
        TrackerTableBriskWalking.upsert(briskWalkings)
        TrackerTablePedometer.upsert(pedometers)
        
        return briskMinutes
    }
    
    // MARK: cycling methods
    
    internal static func analyseSegmentForCycling(_ segment: TrackerDBSegment) -> [TrackerDBSegment] {
        if segment.type == TrackerActivityType.CYCLING.id {
            return [segment]
        }
        
        let splitAndClassified = splitByLocations(segment).map(self.classifySplitSegment)
        let groupFirstPass = groupSegments(splitAndClassified, gapThreshold: 0.0)
        let groupSecondPass = groupSegments(groupFirstPass, gapThreshold: 60.0)
        let groupThirdPass = groupSegments(groupSecondPass, gapThreshold: 300.0)
        return groupThirdPass
    }
    
    internal static func splitByLocations(_ segment: TrackerDBSegment) -> [TrackerDBSegment] {
        if segment.locations.count <= 1 {
            return [segment]
        }
        
        let initialSegment = TrackerDBSegment()
        initialSegment.startDate = segment.startDate
        initialSegment.endDate = segment.startDate
        initialSegment.brisk = segment.brisk
        initialSegment.numberOfBriskChunks = segment.numberOfBriskChunks
        
        var results = segment.locations.filter({ (location) -> Bool in
            // filter out bad accuracy locations
            return location.accuracy <= 65.0
        }).scan(initial: initialSegment, combine: { (lastSegment, location) -> TrackerDBSegment in
            
            // scan over locations and convert into segments
            let newSegment = TrackerDBSegment()
            newSegment.startDate = lastSegment.endDate
            newSegment.endDate = location.date
            newSegment.locations = [location]
            newSegment.type = segment.type
            newSegment.brisk = segment.brisk
            newSegment.numberOfBriskChunks = segment.numberOfBriskChunks
            newSegment.addSteps()
            
            // add distances
            if !lastSegment.locations.isEmpty {
                let lastSegmentLocation = lastSegment.locations.first!
                let coordinateA = location.getCoordinate()
                let coordinateB = lastSegmentLocation.getCoordinate()
                if coordinateA != nil && coordinateB != nil {
                    let distance = TrackerLocationUtils.getDistance(coordinateA!, coordinateB!)
                    newSegment.distanceTravelled = Int(distance)
                }
            }
            
            return newSegment
            
        })
        
        if results.isEmpty {
            return [segment]
        }
        
        let finalSegment = TrackerDBSegment()
        finalSegment.startDate = results.last!.endDate
        finalSegment.endDate = segment.endDate
        finalSegment.type = segment.type
        finalSegment.brisk = segment.brisk
        finalSegment.numberOfBriskChunks = segment.numberOfBriskChunks
        finalSegment.addSteps()
        
        results.append(finalSegment)
        return results
    }
    
    internal static func classifySplitSegment(_ segment: TrackerDBSegment) -> TrackerDBSegment {
        let metersPerStep = Double(segment.distanceTravelled) / Double(segment.steps)
        if metersPerStep > TrackerConstants.STEP_PER_CYCLING_METER {
            segment.type = TrackerActivityType.CYCLING.id
        }
        return segment
        
    }
    
    internal static func groupSegments(_ segments: [TrackerDBSegment], gapThreshold: Double) -> [TrackerDBSegment] {
        return segments.reduce([TrackerDBSegment](), { (currentSegments, thisSegment) -> [TrackerDBSegment] in
            var mutableSegments = currentSegments
            if mutableSegments.isEmpty {
                mutableSegments.append(thisSegment)
                return mutableSegments
            }
            
            let lastSegment = currentSegments.last!
            
            // if different activityType then append new segment
            let differentType = thisSegment.type != lastSegment.type
            let significantLength = abs(thisSegment.startDate!.timeIntervalSince(thisSegment.endDate!)) >= gapThreshold
            
            if differentType && significantLength {
                mutableSegments.append(thisSegment)
                return mutableSegments
            }
            
            // otherwise merge with last segment
            lastSegment.endDate = thisSegment.endDate
            lastSegment.steps += thisSegment.steps
            lastSegment.distanceTravelled += thisSegment.distanceTravelled
            lastSegment.locations.append(contentsOf: thisSegment.locations)
            lastSegment.brisk = thisSegment.brisk
            lastSegment.numberOfBriskChunks = thisSegment.numberOfBriskChunks
            return mutableSegments
        })
    }
}
