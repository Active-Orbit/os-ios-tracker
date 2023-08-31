//
//  TrackerEnvironment.swift
//  Tracker
//
//  Created by Omar Brugna on 08/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerEnvironment {
    
    fileprivate static let trackerBaseUrl = "TrackerBaseUrl"
    fileprivate static let trackerBaseUrl_IT = "TrackerBaseUrl_IT"
    
    public static let BASE_URL = (TrackerBundle.application.infoDictionary?[trackerBaseUrl] ?? TrackerBundle.tracker.infoDictionary?[trackerBaseUrl]) as! String
    public static let BASE_URL_IT = (TrackerBundle.application.infoDictionary?[trackerBaseUrl_IT] ?? TrackerBundle.tracker.infoDictionary?[trackerBaseUrl_IT]) as! String
}
