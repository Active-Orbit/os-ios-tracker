//
//  TrackerPermissions.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

internal class TrackerPermissions: NSObject  {
    
    internal var locationManager: CLLocationManager?
    internal var motionManager: CMMotionActivityManager?
    internal var pedometerManager: CMPedometer?
    
    fileprivate var mGroup: Group!
    
    internal static let REQUEST_ACCESS_LOCATION_WHEN_IN_USE = 0
    internal static let REQUEST_ACCESS_LOCATION_ALWAYS = 1
    internal static let REQUEST_ACCESS_MOTION = 2
    internal static let REQUEST_ACCESS_PEDOMETER = 3
    
    override init() {
        TrackerException("Do not use this constructor for permissions")
    }
    
    init(_ group: Group) {
        mGroup = group
    }
    
    internal static func locationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    internal static func motionAuthorizationStatus() -> CMAuthorizationStatus {
        return CMMotionActivityManager.authorizationStatus()
    }
    
    internal static func pedometerAuthorizationStatus() -> CMAuthorizationStatus {
        return CMPedometer.authorizationStatus()
    }
    
    internal func check() -> Bool {
        switch mGroup.requestCode {
            case TrackerPermissions.REQUEST_ACCESS_LOCATION_WHEN_IN_USE:
                let status = TrackerPermissions.locationAuthorizationStatus()
                return status == .authorizedWhenInUse || status == .authorizedAlways
            case TrackerPermissions.REQUEST_ACCESS_LOCATION_ALWAYS:
                let status = TrackerPermissions.locationAuthorizationStatus()
                return status == .authorizedAlways
            case TrackerPermissions.REQUEST_ACCESS_MOTION:
                let status = TrackerPermissions.motionAuthorizationStatus()
                return status == .authorized
            case TrackerPermissions.REQUEST_ACCESS_PEDOMETER:
                let status = TrackerPermissions.pedometerAuthorizationStatus()
                return status == .authorized
            default:
                TrackerLogger.e("Undefined permission request code on check \(mGroup.requestCode)")
        }
        return false
    }
    
    internal func request(listener: @escaping TrackerClosureBool) {
        switch mGroup.requestCode {
            case TrackerPermissions.REQUEST_ACCESS_LOCATION_WHEN_IN_USE:
                let status = TrackerPermissions.locationAuthorizationStatus()
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    listener(true)
                } else if status == .notDetermined {
                    locationManager?.requestWhenInUseAuthorization()
                } else {
                    listener(false)
                }
            case TrackerPermissions.REQUEST_ACCESS_LOCATION_ALWAYS:
                let status = TrackerPermissions.locationAuthorizationStatus()
                if status == .authorizedAlways {
                    listener(true)
                } else if status == .notDetermined || status == .authorizedWhenInUse {
                    locationManager?.requestAlwaysAuthorization()
                } else {
                    listener(false)
                }
            case TrackerPermissions.REQUEST_ACCESS_MOTION:
                let status = TrackerPermissions.motionAuthorizationStatus()
                if status == .authorized {
                    listener(true)
                } else if status == .notDetermined {
                    motionManager?.queryActivityStarting(from: TrackerTimeUtils.getCurrent(), to: TrackerTimeUtils.getCurrent(), to: .main, withHandler: { _, error in
                        if error != nil && error!._code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                            listener(false)
                        } else {
                            listener(true)
                        }
                    })
                } else {
                    listener(false)
                }
            case TrackerPermissions.REQUEST_ACCESS_PEDOMETER:
                let status = TrackerPermissions.pedometerAuthorizationStatus()
                if status == .authorized {
                    listener(true)
                } else if status == .notDetermined {
                    pedometerManager?.queryPedometerData(from: TrackerTimeUtils.getCurrent(), to: TrackerTimeUtils.getCurrent(), withHandler: { _, error in
                        if error != nil && error!._code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                            listener(false)
                        } else {
                            listener(true)
                        }
                    })
                } else {
                    listener(false)
            }
            default:
                TrackerLogger.e("Undefined permission request code on request \(mGroup.requestCode)")
        }
    }
    
    internal enum Group {
        case ACCESS_LOCATION_WHEN_IN_USE
        case ACCESS_LOCATION_ALWAYS
        case ACCESS_MOTION
        case ACCESS_PEDOMETER
        
        var requestCode: Int {
            switch self {
                case .ACCESS_LOCATION_WHEN_IN_USE: return REQUEST_ACCESS_LOCATION_WHEN_IN_USE
                case .ACCESS_LOCATION_ALWAYS: return REQUEST_ACCESS_LOCATION_ALWAYS
                case .ACCESS_MOTION: return REQUEST_ACCESS_MOTION
                case .ACCESS_PEDOMETER: return REQUEST_ACCESS_PEDOMETER
            }
        }
    }
}
