//
//  TrackerAnalyser.swift
//  Tracker
//
//  Created by Omar Brugna on 30/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerAnalyser {
    
    internal static let instance = TrackerAnalyser()
    
    internal func analyse(_ listener: TrackerClosureVoid? = nil) {
        var startDate = TrackerTimeUtils.getCurrent().startOfDay
        let endDate = TrackerTimeUtils.getCurrent().endOfDay
        
        let firstInstallDate = TrackerPreferences.routine.firstInstall
        if firstInstallDate?.after(startDate) == true {
            startDate = firstInstallDate!
        }
        analyse(startDate, endDate, listener)
    }

    internal func analyse(_ fromDate: Date, _ toDate: Date, _ listener: TrackerClosureVoid? = nil) {
        var segments = [TrackerDBSegment]()
        TrackerMotionManager.instance.getMotionActivities(fromDate: fromDate, toDate: toDate, listener: { activities in
            if activities != nil {
                var validActivities = [TrackerDBActivity]()
                for activity in activities! {
                    // discard activities before the installation date
                    if activity.startDate != nil && TrackerPreferences.routine.firstInstall != nil && activity.startDate!.after(TrackerPreferences.routine.firstInstall!.toUTC()) {
                        // discard stationary activities
                        if activity.activityType != TrackerActivityType.STATIONARY.id && activity.activityType != TrackerActivityType.OTHER.id {
                            validActivities.append(activity)
                        }
                    }
                }
                DispatchQueue.main.async {
                    TrackerTableActivities.deleteBetween(fromDate, toDate)
                    TrackerTableActivities.upsert(validActivities)
                    let activities = TrackerTableActivities.getBetween(fromDate, toDate)
                    segments = self.analyseActivities(activities)
                    TrackerTableSegments.deleteBetween(fromDate, toDate)
                    TrackerTableSegments.upsert(segments)
                    TrackerLogger.d("Analysation completed: \(segments.count) segments generated from \(TrackerTimeUtils.log(fromDate)) to \(TrackerTimeUtils.log(toDate))")
                    listener?()
                }
            } else {
                TrackerLogger.d("Analysation completed: no activities from \(TrackerTimeUtils.log(fromDate)) to \(TrackerTimeUtils.log(toDate))")
                DispatchQueue.main.async {
                    listener?()
                }
            }
        })
    }
    
    internal func analyseActivities(_ activities: [TrackerDBActivity]) -> [TrackerDBSegment] {
        var segments = TrackerSegmentsManager.create(activities)
        segments = TrackerSegmentsManager.getWithoutNoise(segments)
        
        TrackerSegmentsManager.setActivityDurationTo(segments)
        
        let minimumSegmentDuration = TrackerPreferences.configuration.minimumSegmentDuration
        segments = TrackerSegmentsManager.getWithMinimumDuration(segments, minimumSegmentDuration)
        
        if TrackerPreferences.configuration.intensityEnabled {
            TrackerSegmentsManager.setBriskChunksTo(segments)
        }
        
        if TrackerPreferences.configuration.wifyAnalysisEnabled {
            // TODO
            // finalSegments = finalSegments.filter({ return !self.shouldRemoveSegmentBecauseWiFi(segment: $0) })
        }
        
        if TrackerPreferences.configuration.stepsEnabled {
            var pedometers = [TrackerDBPedometer]()
            for segment in segments {
                segment.addSteps()
                let pedometer = segment.getPedometerData()
                if pedometer != nil { pedometers.append(pedometer!) }
            }
            TrackerTablePedometer.upsert(pedometers)
        }
        
        for segment in segments {
            // add locations
            segment.addLocations()
        }
         
        if TrackerPreferences.configuration.cyclingEnabled {
            /*
            segments = segments.reduce([TrackerDBSegment](), { (currentSegments, thisSegment) -> [TrackerDBSegment] in
                var newSegments = currentSegments
                newSegments.append(contentsOf: TrackerSegmentsManager.analyseSegmentForCycling(thisSegment))
                return newSegments
            })
            */
        }
        
        if TrackerPreferences.configuration.automotiveEnabled {
            // TODO
            // finalSegments.append(contentsOf: self.createAutomotiveSegments(activities: self.activitiesToAnalyse))
        }
        
        if !activities.isEmpty {
            for activity in activities {
                activity.analysed = TrackerConstants.TRUE
            }
            
            DispatchQueue.main.async {
                TrackerTableActivities.upsert(activities)
            }
        }
        
        if TrackerPreferences.configuration.logLevel.id >= TrackerLogLevel.MEDIUM.id {
            for segment in segments {
                TrackerLogger.d("Segment created \(segment.description())")
            }
        }
        
        return segments
    }
}
