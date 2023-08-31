//
//  DateExtension.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal extension Date {
    
    init(timeInMillis: Double) {
        self.init(timeIntervalSince1970: timeInMillis / 1000)
    }
    
    var zeroSeconds: Date {
        get {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
            components.second = 0
            components.nanosecond = 0
            return calendar.date(from: components) ?? self
        }
    }
    
    var startOfDay: Date {
        get {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
            components.hour = 0
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
            return calendar.date(from: components) ?? self
        }
    }

    var endOfDay: Date {
        get {
            let calendar = Calendar.current
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return calendar.date(byAdding: components, to: startOfDay)!
        }
    }
    
    var timeInMillis: Double {
        get {
            return Double(timeIntervalSince1970 * 1000)
        }
    }
    
    static var utc: Date {
        get {
            return Date()
        }
    }
    
    static var current: Date {
        get {
            let utcDate = utc
            let timeZoneOffset = Double(TrackerTimeUtils.defaultTimezone.secondsFromGMT(for: utcDate))
            let currentDate = utcDate.add(component: .second, value: Int(timeZoneOffset))
            return currentDate ?? utcDate
        }
    }
    
    func toUTC() -> Date {
        let timeZoneOffset = Double(TrackerTimeUtils.defaultTimezone.secondsFromGMT(for: self))
        let currentDate = add(component: .second, value: Int(-timeZoneOffset))
        return currentDate ?? self
    }
    
    func toCurrent() -> Date {
        let timeZoneOffset = Double(TrackerTimeUtils.defaultTimezone.secondsFromGMT(for: self))
        let currentDate = add(component: .second, value: Int(timeZoneOffset))
        return currentDate ?? self
    }
    
    func before(_ date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }
    
    func after(_ date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }
    
    func add(component: Calendar.Component, value: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: self)
    }
    
    func get(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
    func secondsFrom(_ date: Date) -> Int {
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.second], from: date, to: self).second
        return diff ?? 0
    }
    
    func minutesFrom(_ date: Date) -> Int {
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.minute], from: date, to: self).minute
        return diff ?? 0
    }
    
    func hoursFrom(_ date: Date) -> Int {
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.hour], from: date, to: self).hour
        return diff ?? 0
    }
    
    func daysFrom(_ date: Date) -> Int {
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.day], from: date, to: self).day
        return diff ?? 0
    }
}
