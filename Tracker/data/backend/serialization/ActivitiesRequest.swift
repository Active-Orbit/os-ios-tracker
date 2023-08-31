//
//  ActivitiesRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class ActivitiesRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case userId
        case activities

        var rawValue: String {
            get {
                switch self {
                    case .userId: return "_id"
                    case .activities: return "activities"
                }
            }
        }
    }
    
    internal var userId = TrackerConstants.EMPTY
    internal var activities = [ActivityRequest]()
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(userId) && !activities.isEmpty
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
    
    internal class ActivityRequest: BaseRequest {
        
        fileprivate enum CodingKeys: String, CodingKey {
            case id
            case timeInMsecs
            case type
            case transitionType

            var rawValue: String {
                get {
                    switch self {
                        case .id: return "id"
                        case .timeInMsecs: return "timeInMsecs"
                        case .type: return "type"
                        case .transitionType: return "transitionType"
                    }
                }
            }
        }
        
        internal var id = TrackerConstants.EMPTY
        internal var timeInMsecs: Double = 0
        internal var type = TrackerConstants.INVALID
        internal var transitionType = TrackerConstants.INVALID
        
        init(_ dbActivity: TrackerDBActivity) {
            self.id = dbActivity.activityId
            self.timeInMsecs = dbActivity.startDate?.timeInMillis ?? 0
            self.type = dbActivity.activityType
            self.transitionType = 0 // TODO?
        }
        
        internal func isValid() -> Bool {
            return !TrackerTextUtils.isEmpty(id) &&
                timeInMsecs != 0 &&
                type != TrackerConstants.INVALID
        }
        
        internal func identifier() -> String {
            return TrackerConstants.EMPTY
        }
        
        internal func toJson() -> String? {
            return TrackerGson.toJsonString(self)
        }
    }

}
