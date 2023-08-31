//
//  TrackerMotionManager.swift
//  Tracker
//
//  Created by Omar Brugna on 29/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreMotion

internal class TrackerMotionManager: NSObject {
    
    internal static let instance = TrackerMotionManager()
    
    fileprivate var motionManager = CMMotionActivityManager()
    
    internal let permissionMotion = TrackerPermissions(.ACCESS_MOTION)
}

extension TrackerMotionManager {
    
    // MARK: tracking methods
    
    internal func motionActivityAvailable() -> Bool {
        return CMMotionActivityManager.isActivityAvailable()
    }
    
    internal func getMotionActivities(fromDate: Date, toDate: Date, listener: @escaping ([TrackerDBActivity]?) -> ()) {
        if hasMotionAuthorization() {
            let queue = OperationQueue()
            motionManager.queryActivityStarting(from: fromDate, to: toDate, to: queue, withHandler: { activities, error in
                if error != nil {
                    TrackerLogger.e("Error retrieving motion activities \(error!.localizedDescription)")
                    listener(nil)
                } else {
                    if activities != nil {
                        let filteredActivities = activities!.filter({ !$0.startDate.after(TrackerTimeUtils.getUTC()) })
                        let sortedActivities = filteredActivities.sorted(by: { $0.startDate < $1.startDate })
                        var dbActivities = [TrackerDBActivity]()
                        for index in 0..<sortedActivities.count {
                            let activity = sortedActivities[index]
                            let trackerDBActivity = TrackerDBActivity(activity: activity)
                            if index < sortedActivities.count - 1 {
                                trackerDBActivity.endDate = sortedActivities[index + 1].startDate
                            } else {
                                trackerDBActivity.endDate = TrackerTimeUtils.getUTC()
                            }
                            trackerDBActivity.addSteps()
                            dbActivities.append(trackerDBActivity)
                        }
                        listener(dbActivities)
                    } else {
                        TrackerLogger.w("Motion activities retrieved are null")
                        listener(nil)
                    }
                }
            })
        } else {
            TrackerLogger.w("Motion tracking not started for missing permission")
            listener(nil)
        }
    }
}

extension TrackerMotionManager {
    
    // MARK: authorization methods
    
    internal func requestMotionAuthorization(_ listener: @escaping TrackerClosureBool) {
        if hasMotionAuthorization() {
            listener(true)
        } else {
            permissionMotion.motionManager = motionManager
            permissionMotion.request(listener: { granted in
                if granted {
                    listener(true)
                } else {
                    listener(false)
                }
            })
        }
    }
    
    internal func hasMotionAuthorization() -> Bool {
        return permissionMotion.check()
    }
}
