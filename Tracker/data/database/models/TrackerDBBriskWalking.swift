//
//  TrackerDBBriskWalking.swift
//  Tracker
//
//  Created by Omar Brugna on 30/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

public class TrackerDBBriskWalking : TrackerDBModel {

    @objc dynamic public var briskWalkingId: String = TrackerConstants.EMPTY
    @objc dynamic public var createdAt: Date?
    @objc dynamic public var startDate: Date?
    @objc dynamic public var endDate: Date?
    
    required override init() {
        
    }
    
    public init(briskWalkingId: String) {
        self.briskWalkingId = briskWalkingId
    }
    
    public override class func primaryKey() -> String? {
        return "briskWalkingId"
    }

    override public func identifier() -> String {
        return briskWalkingId
    }

    override public func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(briskWalkingId)
    }
    
    public func description() -> String {
        let createdAtFormatted = TrackerTimeUtils.log(createdAt)
        let startDateFormatted = TrackerTimeUtils.log(startDate)
        let endDateFormatted = TrackerTimeUtils.log(endDate)
        return "[\(briskWalkingId) - \(createdAtFormatted) - \(startDateFormatted) - \(endDateFormatted)]"
    }
}
