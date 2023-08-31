//
//  TrackerApi.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
* Utility enum to declare api urls
*/
internal enum TrackerApi {
    
    case EMPTY
    case INFORMATION_GET
    case INSERT_ACTIVITIES
    case INSERT_BATTERIES
    case INSERT_LOCATIONS
    case INSERT_STEPS
    case INSERT_TRIPS
    case UPLOAD_DATA
    case UPLOAD_NOTES
    case USER_REGISTRATION
    case USER_SIGNUP
    case USER_UPDATE
    case USER_UPDATE_PUSH_TOKEN
    
    var apiUrl: String {
        switch self {
            case .EMPTY: return TrackerConstants.EMPTY
            case .INFORMATION_GET: return "information"
            case .INSERT_ACTIVITIES: return "v2/insert_activities"
            case .INSERT_BATTERIES: return "v2/insert_batteries"
            case .INSERT_LOCATIONS: return "v2/insert_locations"
            case .INSERT_STEPS: return "v2/insert_steps"
            case .INSERT_TRIPS: return "v2/insert_trips"
            case .UPLOAD_DATA: return "multi"
            case .UPLOAD_NOTES: return "diaries"
            case .USER_REGISTRATION: return "user_registration"
            case .USER_SIGNUP: return "user/signup"
            case .USER_UPDATE: return "user/update"
            case .USER_UPDATE_PUSH_TOKEN: return "user/updateFBToken"
        }
    }
}
