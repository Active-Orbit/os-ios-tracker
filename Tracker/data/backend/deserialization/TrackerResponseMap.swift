//
//  TrackerResponseMap.swift
//  Tracker
//
//  Created by Omar Brugna on 13/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerResponseMap: TrackerProtocol, Decodable {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case error = "err"
    }
    
    internal var error: Bool?
    
    internal func isValid() -> Bool {
        return true
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decodeIfPresent(Bool.self, forKey: .error)
    }
}
