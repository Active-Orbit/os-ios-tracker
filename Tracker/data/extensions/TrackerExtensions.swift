//
//  Extensions.swift
//  Tracker
//
//  Created by Omar Brugna on 23/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal typealias JSONDict = [String: Any]
internal typealias JSONArray = [JSONDict]

internal let defaultsStandard = Foundation.UserDefaults.standard

internal func classNameFor(_ type: Any.Type) -> String {
    return String(describing: object_getClassName(type))
}

internal extension NSObject {
    
    var className : String {
        return String(describing: object_getClassName(self))
    }
}
