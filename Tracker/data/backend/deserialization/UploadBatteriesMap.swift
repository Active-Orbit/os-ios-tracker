//
//  UploadBatteriesMap.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class UploadBatteriesMap: TrackerProtocol, Decodable {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case inserted = "inserted"
    }
    
    internal var inserted: Int?
    
    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    internal func isValid() -> Bool {
        return inserted != nil
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inserted = try container.decodeIfPresent(Int.self, forKey: .inserted)
    }
}
