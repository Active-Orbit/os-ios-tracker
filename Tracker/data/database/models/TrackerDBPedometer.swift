//
//  TrackerDBPedometer.swift
//  Tracker
//
//  Created by Omar Brugna on 30/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreMotion
import RealmSwift

public class TrackerDBPedometer : TrackerDBModel {

    @objc dynamic public var pedometerId: String = TrackerConstants.EMPTY
    @objc dynamic public var startDate: Date?
    @objc dynamic public var endDate: Date?
    @objc dynamic public var floorsClimbed: Int = TrackerConstants.INVALID
    @objc dynamic public var numberOfSteps: Int = TrackerConstants.INVALID
    @objc dynamic public var sentToDB: Date?
    
    required override init() {
        
    }
    
    public init(pedometerId: String) {
        self.pedometerId = pedometerId
    }
    
    internal init(data: CMPedometerData) {
        pedometerId = TrackerTimeUtils.format(data.startDate, TrackerConstants.DATE_FORMAT_ID)
        startDate = data.startDate
        endDate = data.endDate
        floorsClimbed = Int(truncating: data.floorsAscended ?? 0)
        numberOfSteps = Int(truncating: data.numberOfSteps)
    }
    
    public override class func primaryKey() -> String? {
        return "pedometerId"
    }

    override public func identifier() -> String {
        return pedometerId
    }

    override public func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(pedometerId)
    }
    
    public func generateId() {
        pedometerId = TrackerTimeUtils.format(startDate, TrackerConstants.DATE_FORMAT_ID)
    }
    
    public func description() -> String {
        let startDateFormatted = TrackerTimeUtils.log(startDate)
        let endDateFormatted = TrackerTimeUtils.log(endDate)
        let sentToDBFormatted = TrackerTimeUtils.log(sentToDB)
        return "[\(pedometerId) - \(startDateFormatted) - \(endDateFormatted) - \(floorsClimbed) - \(numberOfSteps) - \(sentToDBFormatted)]"
    }
    
    public func shouldBeUpdatedWith(_ other: TrackerProtocol?) -> Bool {
        if other is TrackerDBPedometer && identifier() == other?.identifier() {
            let new = other as! TrackerDBPedometer
            return floorsClimbed != new.floorsClimbed ||
                numberOfSteps != new.numberOfSteps
        }
        return false
    }
}
