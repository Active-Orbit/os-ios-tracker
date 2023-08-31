//
//  BaseRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Base request that should be implemented by all the encodable requests
 */
internal protocol BaseRequest: TrackerProtocol, Encodable {
    
    func toJson() -> String?
}
