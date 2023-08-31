//
//  TrackerNetwork.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerNetwork {

    public static let ENCODING_UTF8 = "UTF-8"
    public static let USER_AGENT = "User-Agent"
    public static let CONTENT_TYPE = "Content-Type"
    public static let CONTENT_TYPE_APPLICATION_JSON = "application/json"
    public static let CONNECTION = "Connection"
    public static let CACHE_CONTROL = "Cache-Control"
    public static let KEEP_ALIVE = "Keep-Alive"
    public static let NO_CACHE = "no-cache"
    public static let POST = "POST"
    public static let GET = "GET"
    public static let CONNECTION_TIMEOUT: TimeInterval = 10
    public static let CONNECTION_TIMEOUT_EXTENDED: TimeInterval = 30
    public static let SOCKET_TIMEOUT: TimeInterval = 40
    public static let SOCKET_TIMEOUT_EXTENDED: TimeInterval = 60
}
