//
//  TrackerSequenceExtension.swift
//  Tracker
//
//  Created by Omar Brugna on 13/05/21.
//  Copyright © 2021 Active Orbit. All rights reserved.
//

import Foundation

internal extension Sequence {
    
    func scan<T>(initial: T, combine: (T, Iterator.Element) throws -> T) rethrows -> [T] {
        var accuracy = initial
        return try map { element in
            accuracy = try combine(accuracy, element)
            return accuracy
        }
    }
    
    func limitedTo(_ limit: Int) -> [Element] {
        var limitedModels = [Element]()
        var index = 0
        for model in self {
            index += 1
            limitedModels.append(model)
            if index == limit { break }
        }
        return limitedModels
    }
}
