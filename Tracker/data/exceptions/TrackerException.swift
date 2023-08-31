//
//  TrackerException.swift
//  Tracker
//
//  Created by Omar Brugna on 23/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerException {
    
    @discardableResult
    public init(_ message: String) {
        fatalError(message)
    }
}
