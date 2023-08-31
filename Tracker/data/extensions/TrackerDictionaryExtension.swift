//
//  DictionaryExtension.swift
//  Tracker
//
//  Created by Omar Brugna on 13/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal extension Dictionary {
    
    func merge(_ dict: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // if both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}
