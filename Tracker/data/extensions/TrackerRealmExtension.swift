//
//  TrackerRealmExtension.swift
//  Tracker
//
//  Created by Omar Brugna on 13/06/23.
//  Copyright © 2021 Active Orbit. All rights reserved.
//

import Foundation

import RealmSwift

internal protocol RealmListDetachable {

    func trackerDetached() -> Self
}

@objc internal extension Object {

    func trackerDetached() -> Self {
        let trackerDetached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? Object {
                trackerDetached.setValue(detachable.trackerDetached(), forKey: property.name)
            } else if let list = value as? RealmListDetachable {
                trackerDetached.setValue(list.trackerDetached(), forKey: property.name)
            } else {
                trackerDetached.setValue(value, forKey: property.name)
            }
        }
        return trackerDetached
    }
}

extension List: RealmListDetachable where Element: Object {

    internal func trackerDetached() -> List<Element> {
        let trackerDetached = self.trackerDetached
        let result = List<Element>()
        result.append(objectsIn: trackerDetached)
        return result
    }
}

extension Array: RealmListDetachable where Element: Object {

    internal func trackerDetached() -> Array<Element> {
        let trackerDetached = self.trackerDetached
        var result = Array<Element>()
        result.append(contentsOf: trackerDetached)
        return result
    }
}

internal extension Sequence where Iterator.Element: Object {

    var trackerDetached: [Element] {
        return map({ $0.trackerDetached() })
    }
}

