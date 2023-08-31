//
//  UserRegistrationRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class UserRegistrationRequest: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case phoneModel
        case appVersion
        case androidVersion
        case idProgram
        case idPatient
        case userSex
        case userAge
        case userWeight
        case userHeight
        case batteryLevel
        case isCharging
        case registrationTimestamp

        var rawValue: String {
            get {
                switch self {
                    case .phoneModel: return "phone_model"
                    case .appVersion: return "app_version"
                    case .androidVersion: return "android_version"
                    case .idProgram: return "id_program"
                    case .idPatient: return "participantId"
                    case .userSex: return "userSex"
                    case .userAge: return "userAge"
                    case .userWeight: return "userWeight"
                    case .userHeight: return "userHeight"
                    case .batteryLevel: return "batteryLevel"
                    case .isCharging: return "isCharging"
                    case .registrationTimestamp: return "timeInMsecs"
                }
            }
        }
    }
    
    internal var phoneModel: String?
    internal var appVersion: String?
    internal var androidVersion: String?
    internal var idProgram: String?
    internal var idPatient: String?
    internal var userSex: String?
    internal var userAge: String?
    internal var userWeight: String?
    internal var userHeight: String?
    internal var batteryLevel: Int?
    internal var isCharging = false
    internal var registrationTimestamp: Double?
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(phoneModel) &&
            !TrackerTextUtils.isEmpty(appVersion) &&
            !TrackerTextUtils.isEmpty(androidVersion) &&
            !TrackerTextUtils.isEmpty(idProgram) &&
            !TrackerTextUtils.isEmpty(idPatient) &&
            !TrackerTextUtils.isEmpty(userSex) &&
            !TrackerTextUtils.isEmpty(userAge) &&
            !TrackerTextUtils.isEmpty(userWeight) &&
            !TrackerTextUtils.isEmpty(userHeight) &&
            batteryLevel != nil &&
            registrationTimestamp != nil
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
}
