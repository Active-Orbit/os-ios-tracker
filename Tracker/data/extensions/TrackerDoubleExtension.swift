//
//  TrackerDoubleExtension.swift
//  Tracker
//
//  Created by Omar Brugna on 17/12/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

extension Double {
    
    func roundTo(_ decimals: Int) -> Double {
        let divisor = pow(10.0, Double(decimals))
        return (self * divisor).rounded() / divisor
    }
}
