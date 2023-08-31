//
//  TrackerConfig.swift
//  Tracker
//
//  Created by Omar Brugna on 25/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerConfig {
    
    public init() {}
    
    public var logLevel: TrackerLogLevel?
    public var stepsPerSecondThreshold: Double?
    public var stepsPerBriskMinuteThreshold: Double?
    public var minimumSegmentDuration: Int?
    public var locationTrackingEnabled = true
    public var intensityEnabled = true
    public var stepsEnabled = true
    public var cyclingEnabled = true
    public var automotiveEnabled = true
    public var wifyAnalysisEnabled = true
    public var dataUploadEnabled = true
    public var useLegacyDataUpload = true
    public var userRegistrationEnabled = true
    public var useLegacyUserRegistration = true
}
