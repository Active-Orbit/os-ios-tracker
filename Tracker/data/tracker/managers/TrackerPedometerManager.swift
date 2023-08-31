//
//  TrackerPedometerManager.swift
//  Tracker
//
//  Created by Omar Brugna on 30/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import CoreMotion

internal class TrackerPedometerManager: NSObject {
    
    internal static let instance = TrackerPedometerManager()
    
    fileprivate var pedometerManager = CMPedometer()
    
    internal let permissionPedometer = TrackerPermissions(.ACCESS_PEDOMETER)
}

extension TrackerPedometerManager {
    
    // MARK: tracking methods
    
    internal func pedometerEventTrackingAvailable() -> Bool {
        return CMPedometer.isPedometerEventTrackingAvailable()
    }
    
    internal func getPedometerData(fromDate: Date, toDate: Date, listener: @escaping (TrackerDBPedometer?) -> ()) {
        if !toDate.after(fromDate) {
            TrackerLogger.e("Invalid dates getting pedometer data \(TrackerTimeUtils.log(fromDate)) - \(TrackerTimeUtils.log(toDate))")
            listener(nil)
            return
        }
        
        if hasPedometerAuthorization() {
            pedometerManager.queryPedometerData(from: fromDate, to: toDate, withHandler: { data, error in
                if error != nil {
                    TrackerLogger.e("Error retrieving pedometer data \(error!.localizedDescription)")
                    listener(nil)
                } else {
                    if data != nil {
                        let trackerDBPedometer = TrackerDBPedometer(data: data!)
                        listener(trackerDBPedometer)
                    } else {
                        TrackerLogger.w("Pedometer data retrieved is null")
                        listener(nil)
                    }
                }
            })
        } else {
            TrackerLogger.w("Pedometer tracking not started for missing permission")
            listener(nil)
        }
    }
    
    internal func getPedometerData(_ fromDate: Date, _ toDate: Date) -> TrackerDBPedometer? {
        if !toDate.after(fromDate) {
            TrackerLogger.e("Invalid dates getting pedometer data \(TrackerTimeUtils.log(fromDate)) - \(TrackerTimeUtils.log(toDate))")
            return nil
        }
        
        let group = DispatchGroup()
        group.enter()
        
        var model: TrackerDBPedometer?
        getPedometerData(fromDate: fromDate, toDate: toDate, listener: { data in
            model = data
            group.leave()
        })
        
        _ = group.wait(timeout: DispatchTime.distantFuture)
        return model
    }
    
    internal func getSteps(_ fromDate: Date, _ toDate: Date) -> Int {
        if !toDate.after(fromDate) {
            TrackerLogger.e("Invalid dates getting steps \(TrackerTimeUtils.log(fromDate)) - \(TrackerTimeUtils.log(toDate))")
            return 0
        }
        
        let group = DispatchGroup()
        group.enter()
        
        var steps = 0
        getPedometerData(fromDate: fromDate, toDate: toDate, listener: { data in
            if data != nil {
                steps = data!.numberOfSteps
            }
            group.leave()
        })
        
        _ = group.wait(timeout: DispatchTime.distantFuture)
        return steps
    }
    
    internal func getStepsAndFloorsClimbed(_ fromDate: Date, _ toDate: Date) -> (Int, Int) {
        if !toDate.after(fromDate) {
            TrackerLogger.e("Invalid dates getting steps and floors \(TrackerTimeUtils.log(fromDate)) - \(TrackerTimeUtils.log(toDate))")
            return (0, 0)
        }
        
        let group = DispatchGroup()
        group.enter()
        
        var steps = 0
        var floorsClimbed = 0
        getPedometerData(fromDate: fromDate, toDate: toDate, listener: { data in
            if data != nil {
                steps = data!.numberOfSteps
                floorsClimbed = data!.floorsClimbed
            }
            group.leave()
        })
        
        _ = group.wait(timeout: DispatchTime.distantFuture)
        return (steps, floorsClimbed)
    }
}

extension TrackerPedometerManager {
    
    // MARK: authorization methods
    
    internal func requestPedometerAuthorization(_ listener: @escaping TrackerClosureBool) {
        if hasPedometerAuthorization() {
            listener(true)
        } else {
            permissionPedometer.pedometerManager = pedometerManager
            permissionPedometer.request(listener: { granted in
                if granted {
                    listener(true)
                } else {
                    listener(false)
                }
            })
        }
    }
    
    internal func hasPedometerAuthorization() -> Bool {
        return permissionPedometer.check()
    }
}
