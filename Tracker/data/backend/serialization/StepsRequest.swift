//
//  StepsRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class StepsRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case userId
        case steps

        var rawValue: String {
            get {
                switch self {
                    case .userId: return "_id"
                    case .steps: return "steps"
                }
            }
        }
    }
    
    internal var userId = TrackerConstants.EMPTY
    internal var steps = [StepRequest]()
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(userId) && !steps.isEmpty
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
    
    internal class StepRequest: BaseRequest {
        
        fileprivate enum CodingKeys: String, CodingKey {
            case id
            case timeInMsecs
            case steps

            var rawValue: String {
                get {
                    switch self {
                        case .id: return "id"
                        case .timeInMsecs: return "timeInMsecs"
                        case .steps: return "steps"
                    }
                }
            }
        }
        
        internal var id = TrackerConstants.EMPTY
        internal var timeInMsecs: Double = 0
        internal var steps = TrackerConstants.INVALID
        
        init(_ dbPedometer: TrackerDBPedometer) {
            self.id = dbPedometer.pedometerId
            self.timeInMsecs = dbPedometer.startDate?.timeInMillis ?? 0
            self.steps = dbPedometer.numberOfSteps
        }
        
        internal func isValid() -> Bool {
            return !TrackerTextUtils.isEmpty(id) &&
                timeInMsecs != 0 &&
                steps != TrackerConstants.INVALID
        }
        
        internal func identifier() -> String {
            return TrackerConstants.EMPTY
        }
        
        internal func toJson() -> String? {
            return TrackerGson.toJsonString(self)
        }
    }

}
