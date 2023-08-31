//
//  TrackerDBLocation.swift
//  Tracker
//
//  Created by Omar Brugna on 30/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

public class TrackerDBLocation : TrackerDBModel {

    @objc dynamic public var locationId: String = TrackerConstants.EMPTY
    @objc dynamic public var accuracy: Double = Double(TrackerConstants.INVALID)
    @objc dynamic public var date: Date?
    @objc dynamic public var latitude: Double = Double(TrackerConstants.INVALID)
    @objc dynamic public var longitude: Double = Double(TrackerConstants.INVALID)
    @objc dynamic public var sentToDB: Date?
    @objc dynamic public var wifyBSSID: String?
    @objc dynamic public var analysed: Int = TrackerConstants.INVALID
    
    required override init() {
        
    }
    
    public init(locationId: String) {
        self.locationId = locationId
    }
    
    internal init(location: CLLocation) {
        locationId = TrackerTimeUtils.format(location.timestamp, TrackerConstants.DATE_FORMAT_ID)
        accuracy = location.horizontalAccuracy
        date = location.timestamp
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    public override class func primaryKey() -> String? {
        return "locationId"
    }

    override public func identifier() -> String {
        return locationId
    }

    override public func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(locationId)
    }
    
    public func description() -> String {
        let dateFormatted = TrackerTimeUtils.log(date)
        let sentToDBFormatted = TrackerTimeUtils.log(sentToDB)
        return "[\(locationId) - \(accuracy) - \(dateFormatted) - \(latitude) - \(longitude) - \(sentToDBFormatted) - \(wifyBSSID ?? TrackerConstants.EMPTY) - \(analysed)]"
    }
    
    public func getCoordinate() -> CLLocationCoordinate2D? {
        if latitude != Double(TrackerConstants.INVALID) && longitude != Double(TrackerConstants.INVALID) {
            return TrackerLocationUtils.toLocation(latitude, longitude)
        }
        return nil
    }
    
    public func shouldBeUpdatedWith(_ other: TrackerProtocol?) -> Bool {
        if other is TrackerDBLocation && identifier() == other?.identifier() {
            let new = other as! TrackerDBLocation
            return accuracy != new.accuracy ||
                latitude != new.latitude ||
                longitude != new.longitude
        }
        return false
    }
}
