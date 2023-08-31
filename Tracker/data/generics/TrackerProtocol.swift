//
//  TrackerProtocol.swift
//  Tracker
//
//  Created by Omar Brugna on 02/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
* Base protocol that should be implemented by all the models
*/
public protocol TrackerProtocol {
    
    func isValid() -> Bool

    func identifier() -> String
}
