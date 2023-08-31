//
//  EmptyRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class EmptyRequest: BaseRequest {
    
    internal func isValid() -> Bool {
        return true
    }
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func toJson() -> String? {
        return "{}"
    }
}
