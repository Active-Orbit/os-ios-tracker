//
//  TripsRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class TripsRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case userId
        case trips

        var rawValue: String {
            get {
                switch self {
                    case .userId: return "_id"
                    case .trips: return "trips"
                }
            }
        }
    }
    
    internal var userId = TrackerConstants.EMPTY
    internal var trips = [TripRequest]()
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(userId) && !trips.isEmpty
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
    
    internal class TripRequest: BaseRequest {
        
        fileprivate enum CodingKeys: String, CodingKey {
            case id
            case timeInMsecs
            case startTime
            case endTime
            case activityType
            case radiusInMeters
            case distanceInMeters
            case steps

            var rawValue: String {
                get {
                    switch self {
                        case .id: return "id"
                        case .timeInMsecs: return "timeInMsecs"
                        case .startTime: return "startTime"
                        case .endTime: return "endTime"
                        case .activityType: return "activityType"
                        case .radiusInMeters: return "radiusInMeters"
                        case .distanceInMeters: return "distanceInMeters"
                        case .steps: return "steps"
                    }
                }
            }
        }
        
        internal var id = TrackerConstants.EMPTY
        internal var timeInMsecs: Double = 0
        internal var startTime = Double(TrackerConstants.INVALID)
        internal var endTime = Double(TrackerConstants.INVALID)
        internal var activityType = TrackerConstants.INVALID
        internal var radiusInMeters = TrackerConstants.INVALID
        internal var distanceInMeters = TrackerConstants.INVALID
        internal var steps = TrackerConstants.INVALID
        
        init(_ dbSegment: TrackerDBSegment) {
            self.id = dbSegment.segmentId
            self.timeInMsecs = dbSegment.createdAt?.timeInMillis ?? 0
            self.startTime = dbSegment.startDate?.timeInMillis ?? 0
            self.endTime = dbSegment.endDate?.timeInMillis ?? 0
            self.activityType = dbSegment.type
            self.radiusInMeters = 0 // TODO?
            self.distanceInMeters = 0 // TODO?
            self.steps = dbSegment.steps
        }
        
        internal func isValid() -> Bool {
            return !TrackerTextUtils.isEmpty(id) &&
                timeInMsecs != 0 &&
                startTime != Double(TrackerConstants.INVALID) &&
                endTime != Double(TrackerConstants.INVALID) &&
                activityType != TrackerConstants.INVALID &&
                radiusInMeters != TrackerConstants.INVALID &&
                distanceInMeters != TrackerConstants.INVALID &&
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
