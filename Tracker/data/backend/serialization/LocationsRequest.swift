//
//  LocationsRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class LocationsRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case userId
        case locations

        var rawValue: String {
            get {
                switch self {
                    case .userId: return "_id"
                    case .locations: return "locations"
                }
            }
        }
    }
    
    internal var userId = TrackerConstants.EMPTY
    internal var locations = [LocationRequest]()
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(userId) && !locations.isEmpty
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
    
    internal class LocationRequest: BaseRequest {
        
        fileprivate enum CodingKeys: String, CodingKey {
            case id
            case timeInMsecs
            case latitude
            case longitude
            case altitude
            case accuracy

            var rawValue: String {
                get {
                    switch self {
                        case .id: return "id"
                        case .timeInMsecs: return "timeInMsecs"
                        case .latitude: return "latitude"
                        case .longitude: return "longitude"
                        case .altitude: return "altitude"
                        case .accuracy: return "accuracy"
                    }
                }
            }
        }
        
        internal var id = TrackerConstants.EMPTY
        internal var timeInMsecs: Double = 0
        internal var latitude = Double(TrackerConstants.INVALID)
        internal var longitude = Double(TrackerConstants.INVALID)
        internal var altitude = Double(TrackerConstants.INVALID)
        internal var accuracy = Double(TrackerConstants.INVALID)
        
        init(_ dbLocation: TrackerDBLocation) {
            self.id = dbLocation.locationId
            self.timeInMsecs = dbLocation.date?.timeInMillis ?? 0
            self.latitude = dbLocation.latitude
            self.longitude = dbLocation.longitude
            self.altitude = 0 // TODO?
            self.accuracy = dbLocation.accuracy
        }
        
        internal func isValid() -> Bool {
            return !TrackerTextUtils.isEmpty(id) &&
                timeInMsecs != 0 &&
                latitude != Double(TrackerConstants.INVALID) &&
                longitude != Double(TrackerConstants.INVALID) &&
                altitude != Double(TrackerConstants.INVALID) &&
                accuracy != Double(TrackerConstants.INVALID)
        }
        
        internal func identifier() -> String {
            return TrackerConstants.EMPTY
        }
        
        internal func toJson() -> String? {
            return TrackerGson.toJsonString(self)
        }
    }

}
