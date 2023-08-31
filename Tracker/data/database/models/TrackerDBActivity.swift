//
//  TrackerDBActivity.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreMotion
import RealmSwift

public class TrackerDBActivity : TrackerDBModel {

    @objc dynamic public var activityId: String = TrackerConstants.EMPTY
    @objc dynamic public var activityType: Int = TrackerConstants.INVALID
    @objc dynamic public var confidence: Int = TrackerConstants.INVALID
    @objc dynamic public var createdAt: Date?
    @objc dynamic public var startDate: Date?
    @objc dynamic public var endDate: Date?
    @objc dynamic public var floorsClimbed: Int = TrackerConstants.INVALID
    @objc dynamic public var pedometerChecked: Int = TrackerConstants.INVALID
    @objc dynamic public var sentToDB: Date?
    @objc dynamic public var steps: Int = TrackerConstants.INVALID
    @objc dynamic public var analysed: Int = TrackerConstants.FALSE
    
    required override init() {
        
    }
    
    public init(activityId: String) {
        self.activityId = activityId
    }
    
    internal init(activity: CMMotionActivity) {
        activityId = TrackerTimeUtils.format(activity.startDate, TrackerConstants.DATE_FORMAT_ID)
        activityType = TrackerActivityType.getByActivity(activity).id
        createdAt = TrackerTimeUtils.getUTC()
        startDate = activity.startDate
        endDate = activity.startDate
        confidence = activity.confidence.rawValue
        steps = 0
        floorsClimbed = 0
    }
    
    public override class func primaryKey() -> String? {
        return "activityId"
    }

    override public func identifier() -> String {
        return activityId
    }

    override public func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(activityId)
    }
    
    public func generateId() {
        activityId = TrackerTimeUtils.format(startDate, TrackerConstants.DATE_FORMAT_ID)
    }
    
    public func description() -> String {
        let activityTypeFormatted = TrackerActivityType.getById(activityType)
        let createdAtFormatted = TrackerTimeUtils.log(createdAt)
        let startDateFormatted = TrackerTimeUtils.log(startDate)
        let endDateFormatted = TrackerTimeUtils.log(endDate)
        let sentToDBFormatted = TrackerTimeUtils.log(sentToDB)
        return "[\(activityId) - \(activityTypeFormatted) - \(duration()) - \(confidence) - \(createdAtFormatted) - \(startDateFormatted) - \(endDateFormatted) - \(floorsClimbed) - \(pedometerChecked) - \(sentToDBFormatted) - \(steps) - \(analysed)]"
    }
    
    public func shouldBeUpdatedWith(_ other: TrackerProtocol?) -> Bool {
        if other is TrackerDBActivity && identifier() == other?.identifier() {
            let new = other as! TrackerDBActivity
            return activityType != new.activityType ||
                confidence != new.confidence ||
                floorsClimbed != new.floorsClimbed ||
                steps != new.steps
        }
        return false
    }
    
    public func duration() -> Int {
        if startDate != nil && endDate != nil {
            return endDate!.secondsFrom(startDate!)
        }
        return 0
    }
    
    public func addSteps() {
        if startDate != nil && endDate != nil {
            steps = TrackerPedometerManager.instance.getSteps(startDate!, endDate!)
        }
    }
}
