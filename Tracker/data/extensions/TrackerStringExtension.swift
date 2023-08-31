//
//  StringExtension.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal extension String {

    func limitTo(length: Int) -> String {
        if count <= length {
            return self
        }
        return String(Array(self).prefix(upTo: length))
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func indexOf(_ character: Character) -> Int {
        return firstIndex(of: character)?.utf16Offset(in: self) ?? -1
    }
    
    func charAt(_ at: Int) -> Character {
        let charIndex = index(startIndex, offsetBy: at)
        return self[charIndex]
    }
}
