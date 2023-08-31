//
//  UserRegistrationMap.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class UserRegistrationMap : TrackerProtocol, Decodable {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case id = "_id"
        case phoneModel = "phone_model"
        case androidVersion = "android_version"
        case appVersion = "app_version"
        case participantId = "participantId"
        case participantIdCounter = "participantIdCounter"
    }
    
    internal var id: String? = TrackerConstants.EMPTY
    internal var phoneModel: String? = TrackerConstants.EMPTY
    internal var androidVersion: String? = TrackerConstants.EMPTY
    internal var appVersion: String? = TrackerConstants.EMPTY
    internal var participantId: String? = TrackerConstants.EMPTY
    internal var participantIdCounter: Int? = TrackerConstants.INVALID
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func isValid() -> Bool {
        return !TrackerTextUtils.isEmpty(id) &&
            !TrackerTextUtils.isEmpty(phoneModel) &&
            !TrackerTextUtils.isEmpty(androidVersion) &&
            !TrackerTextUtils.isEmpty(appVersion) &&
            !TrackerTextUtils.isEmpty(participantId)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.phoneModel = try container.decodeIfPresent(String.self, forKey: .phoneModel)
        self.androidVersion = try container.decodeIfPresent(String.self, forKey: .androidVersion)
        self.appVersion = try container.decodeIfPresent(String.self, forKey: .appVersion)
        self.participantId = try container.decodeIfPresent(String.self, forKey: .participantId)
        self.participantIdCounter = try container.decodeIfPresent(Int.self, forKey: .participantIdCounter)
    }
}
