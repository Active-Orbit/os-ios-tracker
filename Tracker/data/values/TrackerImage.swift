//
//  TrackerImage.swift
//  Tracker
//
//  Created by Omar Brugna on 23/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

public class TrackerImage {
    
    public static func get(_ named: String, bundle: Bundle = TrackerBundle.application) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(named: named, in: bundle, compatibleWith: .current)
        } else {
            return UIImage(named: named, in: bundle, compatibleWith: .none)
        }
    }
}
