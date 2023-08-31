//
//  TrackerDBSegment.swift
//  Tracker
//
//  Created by Omar Brugna on 30/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

public class TrackerDBSegment : TrackerDBModel {
    
    @objc dynamic public var segmentId: String = TrackerConstants.EMPTY
    @objc dynamic public var type: Int = TrackerConstants.INVALID
    @objc dynamic public var activityDuration: Int = TrackerConstants.INVALID
    @objc dynamic public var brisk: Int = TrackerConstants.INVALID
    @objc dynamic public var createdAt: Date?
    @objc dynamic public var startDate: Date?
    @objc dynamic public var endDate: Date?
    @objc dynamic public var floorsClimbed: Int = TrackerConstants.INVALID
    @objc dynamic public var distanceTravelled: Int = TrackerConstants.INVALID
    @objc dynamic public var numberOfBriskChunks: Int = TrackerConstants.INVALID
    @objc dynamic public var sentToDB: Date?
    @objc dynamic public var steps: Int = TrackerConstants.INVALID
    @objc dynamic public var userChanged: Int = TrackerConstants.INVALID
    
    public var activities = [TrackerDBActivity]()
    public var locations = [TrackerDBLocation]()
    
    required override init() {
        self.createdAt = TrackerTimeUtils.getUTC()
    }
    
    public init(segmentId: String) {
        self.segmentId = segmentId
        self.createdAt = TrackerTimeUtils.getUTC()
    }
    
    public override class func primaryKey() -> String? {
        return "segmentId"
    }
    
    public override class func ignoredProperties() -> [String] {
        return ["activities", "locations"]
    }
    
    override public func identifier() -> String {
        return segmentId
    }
    
    override public func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(segmentId)
    }
    
    public func generateId() {
        segmentId = TrackerTimeUtils.format(startDate, TrackerConstants.DATE_FORMAT_ID)
    }
    
    public func description() -> String {
        let typeFormatted = TrackerActivityType.getById(type)
        let createdAtFormatted = TrackerTimeUtils.log(createdAt)
        let startDateFormatted = TrackerTimeUtils.log(startDate)
        let endDateFormatted = TrackerTimeUtils.log(endDate)
        let sentToDBFormatted = TrackerTimeUtils.log(sentToDB)
        return "[\(segmentId) - \(typeFormatted) - \(activityDuration) - \(brisk) - \(createdAtFormatted) - \(startDateFormatted) - \(endDateFormatted) - \(floorsClimbed) - \(distanceTravelled) - \(numberOfBriskChunks) - \(sentToDBFormatted) - \(steps) - \(userChanged)]"
    }
    
    public func shouldBeUpdatedWith(_ other: TrackerProtocol?) -> Bool {
        if other is TrackerDBSegment && identifier() == other?.identifier() {
            let new = other as! TrackerDBSegment
            
            if userChanged == TrackerConstants.TRUE && new.userChanged == TrackerConstants.INVALID {
                // the user manually updated the activity type in the past, keep this change
                new.type = type
                new.userChanged = TrackerConstants.TRUE
            }
            
            return type != new.type ||
                activityDuration != new.activityDuration ||
                brisk != new.brisk ||
                floorsClimbed != new.floorsClimbed ||
                distanceTravelled != new.distanceTravelled ||
                numberOfBriskChunks != new.numberOfBriskChunks ||
                steps != new.steps
        }
        return false
    }
    
    public func updateActivityType(_ activityType: TrackerActivityType) {
        type = activityType.id
        userChanged = TrackerConstants.TRUE
        TrackerTableSegments.upsert(self)
    }
    
    public func addLocations() {
        if startDate != nil && endDate != nil {
            locations = TrackerTableLocations.getBetween(startDate!, endDate!)
        }
    }
    
    public func addSteps() {
        if startDate != nil && endDate != nil {
            steps = TrackerPedometerManager.instance.getSteps(startDate!, endDate!)
        }
    }
    
    public func getDuration(_ types: [TrackerActivityType]? = nil) -> Int {
        if types == nil || types!.contains(TrackerActivityType.getById(type)) {
            if startDate != nil && endDate != nil {
                return endDate!.secondsFrom(startDate!)
            }
        }
        return 0
    }
    
    public func getDistance(_ types: [TrackerActivityType]? = nil, _ fallbackToStepsLength: Bool = false) -> Double {
        let stepLength: Double = 0.754
        var totalDistance: Double = 0
        
        if types == nil || types!.contains(TrackerActivityType.getById(type)) {
            if startDate != nil && endDate != nil {
                let filteredLocations = locations.filter { location -> Bool in
                    return location.accuracy != Double(TrackerConstants.INVALID) && location.accuracy <= 65.0
                }
                
                if filteredLocations.count >= 2 {
                    let coordinates: [CLLocationCoordinate2D] = filteredLocations.map({ location -> CLLocationCoordinate2D in
                        return TrackerLocationUtils.toLocation(location.latitude, location.longitude)
                    })
                    for index in 0..<coordinates.count {
                        if index > 0 {
                            let currentCoordinate = coordinates[index]
                            let previousCoordinate = coordinates[index - 1]
                            totalDistance += TrackerLocationUtils.getDistance(previousCoordinate, currentCoordinate)
                        }
                    }
                } else if fallbackToStepsLength {
                    totalDistance = Double(steps) * stepLength
                }
                if totalDistance == 0 && fallbackToStepsLength {
                    totalDistance = Double(steps) * stepLength
                }
            }
        }
        return totalDistance
    }
    
    public func getCalories() -> Int? {
        let calories = TrackerCaloriesUtils.getCaloriesFor(self)
        return calories != nil ? Int(calories!) : nil
    }
    
    public func getStepsSegmented() -> [TrackerStepModel] {
        var segmentedSteps = [TrackerStepModel]()
        if startDate != nil && endDate != nil {
            var fromDate = startDate!
            var toDate = min(fromDate.add(component: .minute, value: 1)!, endDate!)
            while endDate!.after(fromDate) {
                let stepsCount = TrackerPedometerManager.instance.getSteps(fromDate, toDate)
                let model = TrackerStepModel()
                model.startDate = fromDate
                model.endDate = endDate!
                model.stepsCount = stepsCount
                segmentedSteps.append(model)
                
                fromDate = fromDate.add(component: .minute, value: 1)!
                toDate = min(fromDate.add(component: .minute, value: 1)!, endDate!)
            }
        }
        return segmentedSteps
    }
    
    public func addBrisk() {
        if startDate != nil && endDate != nil {
            let segmentDuration = getDuration()
            let segmentSteps = TrackerPedometerManager.instance.getSteps(startDate!, endDate!)
            let segmentStepsPerSecond = Double(segmentSteps) / Double(segmentDuration)
            brisk = segmentStepsPerSecond > 1.6 ? TrackerConstants.TRUE : TrackerConstants.FALSE
        }
    }
    
    public func getPedometerData() -> TrackerDBPedometer? {
        if startDate != nil && endDate != nil {
            return TrackerPedometerManager.instance.getPedometerData(startDate!, endDate!)
        }
        return nil
    }
    
    public func sameActivityTypeOf(_ activityType: Int) -> Bool {
        return type == activityType ||
            type == TrackerActivityType.WALKING.id && activityType == TrackerActivityType.RUNNING.id ||
            type == TrackerActivityType.RUNNING.id && activityType == TrackerActivityType.WALKING.id
    }
}
