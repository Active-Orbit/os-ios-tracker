//
//  TrackerLocaleUtils.swift
//  Tracker
//
//  Created by Omar Brugna on 08/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerLocaleUtils {

    public static func isItalianLanguage() -> Bool {
        return Locale.current.languageCode?.caseInsensitiveCompare("it") == ComparisonResult.orderedSame
    }
}
