//
//  TrackerTimeUtils.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
* Utility class that provides some useful methods to manage timestamps
*/
public class TrackerTimeUtils {

    public static let ONE_SECOND_MILLIS: Double = 1000
    public static let ONE_MINUTE_MILLIS: Double = 60 * ONE_SECOND_MILLIS
    public static let ONE_HOUR_MILLIS: Double = 60 * ONE_MINUTE_MILLIS
    public static let ONE_DAY_MILLIS: Double = 24 * ONE_HOUR_MILLIS

    public static let utcTimezone = TimeZone(abbreviation: "UTC")!
    public static let defaultTimezone = TimeZone.current

    public static func getUTC() -> Date {
        return Date.utc
    }

    public static func getCurrent() -> Date {
        return Date.current
    }

    public static func fromUTC(_ date: String?) -> Date? {
        return parse(date, TrackerConstants.DATE_FORMAT_UTC)
    }

    public static func toUTC(_ date: Date) -> Date {
        return date.toUTC()
    }

    public static func toDefault(_ date: Date) -> Date {
        return date.toCurrent()
    }

    public static func getZeroSeconds(_ fromDate: Date? = nil) -> Date {
        let date = fromDate ?? getCurrent()
        return date.zeroSeconds
    }
    
    /**
     Transform a UTC string date in a readable date
     For example, "2015-10-07 23:12:26" can become "today 23:12"
     
     - parameter stringDate the input string containings date
     - returns: the readable string date
     */
    public static func getReadableDate(_ date: Date, _ skipFuture: Bool) -> String {
        var formattedDate = date
        
        // get current local hour
        var now = getCurrent()

        // can't handle future dates, compare in local
        if skipFuture && date.after(now) {
            now = now.addingTimeInterval(TimeInterval(-60))
            formattedDate = now
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        formatter.locale = .current
        
        return formatter.string(from: formattedDate)
    }
    
    public static func log(_ date: Date?) -> String {
        return TrackerTimeUtils.format(date, TrackerConstants.DATE_FORMAT_FULL, TrackerTimeUtils.defaultTimezone)
    }
    
    public static func formattedTime(_ fromDate: Date?, _ toDate: Date?) -> String {
        guard fromDate != nil && toDate != nil && toDate!.after(fromDate!) else { return "0 min" }
        let minutes = toDate!.minutesFrom(fromDate!)
        if minutes < 60 {
            return "\(minutes) min"
        }
        let hours = minutes / 60
        return "\(hours)h \(minutes % 60) min"
    }

    public static func format(_ date: Date?, _ toFormat: String, _ timezone: TimeZone = defaultTimezone) -> String {
        guard date != nil else { return TrackerConstants.EMPTY }
        let formatter = DateFormatter()
        formatter.dateFormat = toFormat
        formatter.timeZone = timezone
        return formatter.string(from: date!)
    }

    public static func parse(_ date: String?, _ fromFormat: String) -> Date? {
        if TrackerTextUtils.isEmpty(date) {
            TrackerLogger.e("Trying to parse an empty date string")
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        formatter.timeZone = utcTimezone
        let dateParsed = formatter.date(from: date!)
        if dateParsed != nil {
            return dateParsed
        } else {
            TrackerLogger.e("Parsed date is null \(date!)")
        }
        return nil
    }
    
    public static func convertDate(_ date: String, _ fromFormat: String, _ toFormat: String) -> String {
        let date = parse(date, fromFormat)
        if date != nil {
            return format(date!, toFormat)
        }
        return TrackerConstants.EMPTY
    }

    fileprivate static func getCurrentDay() -> Int {
        return getCurrent().get(component: .day)
    }
    
    fileprivate static func getCurrentMonth() -> Int {
        return getCurrent().get(component: .month)
    }
    
    fileprivate static func getCurrentYear() -> Int {
        return getCurrent().get(component: .year)
    }

    public static func isToday(_ date: Date?) -> Bool {
        return isThisMonth(date) && date?.get(component: .day) == getCurrentDay()
    }
    
    public static func isThisMonth(_ date: Date?) -> Bool {
        return isThisYear(date) && date?.get(component: .month) == getCurrentMonth()
    }
    
    public static func isThisYear(_ date: Date?) -> Bool {
        return date?.get(component: .year) == getCurrentYear()
    }
    
    public static func isSameDay(_ dateStart: Date?, _ dateEnd: Date?) -> Bool {
        return dateStart?.get(component: .day) == dateEnd?.get(component: .day) &&
            dateStart?.get(component: .month) == dateEnd?.get(component: .month) &&
            dateStart?.get(component: .year) == dateEnd?.get(component: .year)
    }
}
