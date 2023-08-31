//
//  TrackerColor.swift
//  Tracker
//
//  Created by Omar Brugna on 23/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

public class TrackerColor {
    
    public static func get(_ named: String, bundle: Bundle = TrackerBundle.application) -> UIColor? {
        if #available(iOS 13.0, *) {
            return UIColor(named: named, in: bundle, compatibleWith: .current)
        } else {
            return UIColor(named: named, in: bundle, compatibleWith: .none)
        }
    }
}
