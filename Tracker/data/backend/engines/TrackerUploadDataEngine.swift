//
//  TrackerUploadDataEngine.swift
//  Tracker
//
//  Created by Omar Brugna on 12/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerUploadDataEngine {
    
    internal static func uploadData(_ forced: Bool = false) {
        
        guard TrackerPreferences.options.uploadDataAgreed else {
            TrackerLogger.d("Data upload cancelled because user did not agree")
            return
        }
        
        if !forced {
            let lastDataUpload = TrackerPreferences.routine.lastDataUpload
            if lastDataUpload != nil && TrackerTimeUtils.getCurrent().hoursFrom(lastDataUpload!) < TrackerConstants.DATA_UPLOAD_FREQUENCY_HOURS {
                // too early to send data
                return
            }
        }
        
        let userId = TrackerPreferences.user.id
        guard !TrackerTextUtils.isEmpty(userId) else {
            TrackerLogger.d("Data upload cancelled because the user is not registered yet")
            TrackerApiManager.registerUser()
            return
        }
        
        upload()
    }
    
    fileprivate static func upload() {
        if TrackerPreferences.configuration.useLegacyDataUpload {
            UploaderLegacy.uploadData()
        } else {
            var callbacks = 0
            let callbacksExpected = 5
            
            ActivitiesUploader.uploadData({ success in
                callbacks += 1
                if callbacks == callbacksExpected {
                    if !everythingSent() {
                        upload()
                    }
                }
            })
            
            BatteriesUploader.uploadData({ success in
                callbacks += 1
                if callbacks == callbacksExpected {
                    if !everythingSent() {
                        upload()
                    }
                }
            })
            
            LocationsUploader.uploadData({ success in
                callbacks += 1
                if callbacks == callbacksExpected {
                    if !everythingSent() {
                        upload()
                    }
                }
            })
            
            StepsUploader.uploadData({ success in
                callbacks += 1
                if callbacks == callbacksExpected {
                    if !everythingSent() {
                        upload()
                    }
                }
            })
            
            TripsUploader.uploadData({ success in
                callbacks += 1
                if callbacks == callbacksExpected {
                    if !everythingSent() {
                        upload()
                    }
                }
            })
        }
    }
    
    fileprivate static func everythingSent() -> Bool {
        let maxDate = TrackerTimeUtils.getUTC()
        let maxDateMidnight = TrackerTimeUtils.getUTC().startOfDay
        
        let activities = TrackerTableActivities.getNotSent(maxDate)
        // TODO
        // let batteries = TrackerTableBatteries.getNotSent(maxDate)
        let locations = TrackerTableLocations.getNotSent(maxDate)
        let steps = TrackerTablePedometer.getNotSent(maxDate)
        let trips = TrackerTableSegments.getNotSent(maxDateMidnight)
        // TODO
        // let summaries = TrackerTableSummaries.getNotSent(maxDateMidnight)
        return activities.isEmpty && locations.isEmpty && steps.isEmpty && trips.isEmpty
    }
}
