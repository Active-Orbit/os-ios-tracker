//
//  TrackerUtils.swift
//  Tracker
//
//  Created by Omar Brugna on 16/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Alamofire

public class TrackerUtils {
    
    fileprivate static var alamofireManager: Session!
    
    #if os(iOS)
    
    public static func testTrackerIntegration(_ completionHandler: @escaping (Bool, String?) -> ()) {
        let webservice = TrackerWebService<EmptyRequest>(.EMPTY)
        webservice.method = .get
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    completionHandler(true, nil)
                case .ERROR:
                    completionHandler(false, "Tracker integration error. Please check Alamofire pod integration on main project")
                default:
                    break
            }
        }).connect()
    }
    
    public static func getPhoneModel() -> String? {
        return UIDevice.current.name
    }
    
    public static func getIosVersion() -> String? {
        return "Ios " + UIDevice.current.systemName + " - " + UIDevice.current.systemVersionString
    }
    
    public static func getBatteryPercentage() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return Int(UIDevice.current.batteryLevel * 100)
    }
    
    public static func isCharging() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        switch UIDevice.current.batteryState {
            case .charging, .full:
                return true
            default:
                return false
        }
    }
    
    #endif
    
    public static func getAppName() -> String? {
        return TrackerBundle.application.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    public static func getPackageName() -> String? {
        return TrackerBundle.application.bundleIdentifier
    }
    
    public static func getVersionName() -> String? {
        return TrackerBundle.application.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public static func getVersionCode() -> String? {
        return TrackerBundle.application.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
    
    public static func getAppVersion() -> String? {
        return "Ios " + (getVersionName() ?? TrackerConstants.EMPTY)
    }
    
    public static func delay(milliseconds: Int, code: @escaping TrackerClosureVoid) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: code)
    }
    
    public static func isSimulator() -> Bool {
        #if TARGET_IPHONE_SIMULATOR
        return true
        #else
        return false
        #endif
    }
}
