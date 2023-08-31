//
//  TrackerConstants.swift
//  Tracker
//
//  Created by Omar Brugna on 17/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreGraphics

public class TrackerConstants {
    
    public static let EMPTY = ""
    public static let INVALID = -1
    public static let TRUE = 1
    public static let FALSE = 0
    
    public static let DATABASE_ENCRYPTION_KEY = "000Th3D4t4b4s31s3ncrYpt3d?000"
    
    public static let DATE_FORMAT_ID = "yyyyMMddHHmmss"
    public static let DATE_FORMAT_UTC = "yyyy-MM-dd HH:mm:ss"
    public static let DATE_FORMAT_ISO = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    public static let DATE_FORMAT_ISO_NO = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    public static let DATE_FORMAT_FULL = "dd/MM/yyyy HH:mm:ss"
    public static let DATE_FORMAT_DAY_MONTH_YEAR = "dd/MM/yyyy"
    public static let DATE_FORMAT_DAY_MONTH = "dd\nMMM"
    public static let DATE_FORMAT_HOUR_MINUTE = "HH:mm"
    
    public static let ALPHA_ENABLED: CGFloat = 1.0
    public static let ALPHA_DISABLED: CGFloat = 0.5
    public static let ALPHA_PRESSED: CGFloat = 0.5
    
    public static let BRISK_CHUNKS_THRESHOLD = 5
    public static let BRISK_SECONDS_THRESHOLD = 120
    public static let BRISK_CHUNK_LENGTH = 15.0
    
    public static let STEPS_PER_SECOND_THRESHOLD = 0.2
    public static let STEPS_PER_BRISK_MINUTE_THRESHOLD = 100.0
    public static let STEP_PER_CYCLING_METER = 1.2
    public static let STATIONARY_SECONDS = 120
    
    public static let MINIMUM_SEGMENT_DURATION = 120
    
    public static let DISTANCE_FILTER = 10
    
    public static let DATA_UPLOAD_LIMIT = 300
    
    public static let ANALYSE_FREQUENCY_MINUTES = 2
    public static let USER_UPDATE_FREQUENCY_HOURS = 2
    public static let DATA_UPLOAD_FREQUENCY_HOURS = 2
    public static let NOTES_UPLOAD_FREQUENCY_HOURS = 2
}
