//
//  BatteriesRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class BatteriesRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case userId
        case batteries

        var rawValue: String {
            get {
                switch self {
                    case .userId: return "user_id"
                    case .batteries: return "batteries"
                }
            }
        }
    }
    
    internal var userId = TrackerConstants.EMPTY
    internal var batteries = [BatteryRequest]()
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(userId) && !batteries.isEmpty
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
    
    internal class BatteryRequest: BaseRequest {
        
        fileprivate enum CodingKeys: String, CodingKey {
            case id
            case timeInMsecs
            case batteryPercent
            case isCharging

            var rawValue: String {
                get {
                    switch self {
                        case .id: return "id"
                        case .timeInMsecs: return "timeInMsecs"
                        case .batteryPercent: return "batteryPercent"
                        case .isCharging: return "isCharging"
                    }
                }
            }
        }
        
        internal var id = TrackerConstants.EMPTY
        internal var timeInMsecs: Double = 0
        internal var batteryPercent = TrackerConstants.INVALID
        internal var isCharging = false
        
        internal func isValid() -> Bool {
            return !TrackerTextUtils.isEmpty(id) &&
                timeInMsecs != 0 &&
                batteryPercent != TrackerConstants.INVALID
        }
        
        internal func identifier() -> String {
            return TrackerConstants.EMPTY
        }
        
        internal func toJson() -> String? {
            return TrackerGson.toJsonString(self)
        }
    }

}
