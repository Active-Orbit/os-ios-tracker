//
//  BaseDataRequest.swift
//  Tracker
//
//  Created by Omar Brugna on 30/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class BaseDataRequest<T : BaseRequest>: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case data

        var rawValue: String {
            get {
                switch self {
                    case .data: return "data"
                }
            }
        }
    }

    internal var data: T?
    
    internal func isValid() -> Bool {
        return data?.isValid() == true
    }

    internal func identifier() -> String {
        return TrackerConstants.EMPTY
    }
    
    open func toJson() -> String? {
        return TrackerGson.toJsonString(self)
    }
}
