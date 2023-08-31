//
//  TrackerUserMap.swift
//  Tracker
//
//  Created by Omar Brugna on 12/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerUserMap: TrackerProtocol, Decodable {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case error = "err"
        case userID = "userID"
    }
    
    internal var error: Bool?
    internal var userID: String?
    
    internal func isValid() -> Bool {
        return true
    }
    
    internal func identifier() -> String {
        return userID ?? TrackerConstants.EMPTY
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decodeIfPresent(Bool.self, forKey: .error)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
    }
}
