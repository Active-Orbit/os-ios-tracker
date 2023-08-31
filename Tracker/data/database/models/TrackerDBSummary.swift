//
//  TrackerDBSummary.swift
//  Tracker
//
//  Created by Omar Brugna on 30/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

public class TrackerDBSummary : TrackerDBModel {

    @objc dynamic public var summaryId: String = TrackerConstants.EMPTY
    @objc dynamic public var date: Date?
    @objc dynamic public var floorsClimbed: Int = TrackerConstants.INVALID
    @objc dynamic public var numberOfSteps: Int = TrackerConstants.INVALID
    @objc dynamic public var timeWalking: Int = TrackerConstants.INVALID
    @objc dynamic public var timeRunning: Int = TrackerConstants.INVALID
    @objc dynamic public var timeCycling: Int = TrackerConstants.INVALID
    @objc dynamic public var timeAutomotive: Int = TrackerConstants.INVALID
    @objc dynamic public var timeOther: Int = TrackerConstants.INVALID
    @objc dynamic public var briskWalking: Int = TrackerConstants.INVALID
    @objc dynamic public var distanceWalking: Int = TrackerConstants.INVALID
    @objc dynamic public var distanceCycling: Int = TrackerConstants.INVALID
    @objc dynamic public var distanceRunning: Int = TrackerConstants.INVALID
    @objc dynamic public var distanceAutomotive: Int = TrackerConstants.INVALID
    @objc dynamic public var distanceOther: Int = TrackerConstants.INVALID
    @objc dynamic public var weekly: Int = TrackerConstants.INVALID
    @objc dynamic public var sentToDB: Date?
    
    required override init() {
        
    }
    
    public init(summaryId: String) {
        self.summaryId = summaryId
    }
    
    public override class func primaryKey() -> String? {
        return "summaryId"
    }

    override public func identifier() -> String {
        return summaryId
    }

    override public func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(summaryId)
    }
    
    public func generateId() {
        summaryId = TrackerTimeUtils.format(date, TrackerConstants.DATE_FORMAT_ID)
    }
    
    public func description() -> String {
        let dateFormatted = TrackerTimeUtils.log(date)
        let sentToDBFormatted = TrackerTimeUtils.log(sentToDB)
        return "[\(summaryId) - \(dateFormatted) - \(floorsClimbed) - \(numberOfSteps) - \(timeWalking) - \(timeRunning) - \(timeCycling) - \(timeAutomotive) - \(timeOther) - \(briskWalking) - \(distanceWalking) - \(distanceCycling) - \(distanceRunning) - \(distanceAutomotive) - \(distanceOther) - \(weekly) - \(sentToDBFormatted)]"
    }
    
    public func shouldBeUpdatedWith(_ other: TrackerProtocol?) -> Bool {
        if other is TrackerDBSummary && identifier() == other?.identifier() {
            let new = other as! TrackerDBSummary
            return floorsClimbed != new.floorsClimbed ||
                numberOfSteps != new.numberOfSteps ||
                timeWalking != new.timeWalking ||
                timeRunning != new.timeRunning ||
                timeCycling != new.timeCycling ||
                timeAutomotive != new.timeAutomotive ||
                timeOther != new.timeOther ||
                briskWalking != new.briskWalking ||
                distanceWalking != new.distanceWalking ||
                distanceRunning != new.distanceRunning ||
                distanceAutomotive != new.distanceAutomotive ||
                distanceOther != new.distanceOther
        }
        return false
    }
}
