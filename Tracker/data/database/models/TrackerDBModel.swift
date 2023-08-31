//
//  TrackerDBModel.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
* Base database model that should be extended from other database models
*/
open class TrackerDBModel : Object, TrackerProtocol {
    
    open func isValid() -> Bool {
        TrackerException("Is valid method must never be called on the base class")
        return false
    }

    open func identifier() -> String {
        TrackerLogger.e("Called base identifier method, this should never happen")
        return TrackerConstants.EMPTY
    }
}
