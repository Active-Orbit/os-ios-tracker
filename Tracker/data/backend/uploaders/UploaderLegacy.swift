//
//  UploaderLegacy.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class UploaderLegacy {
    
    internal static var isUploading = false
    
    internal static func uploadData() {
        
        guard !isUploading else {
            TrackerLogger.d("Data upload cancelled because it's already in progress")
            return
        }
        
        let maxDate = TrackerTimeUtils.getUTC()
        let maxDateSummaries = TrackerTimeUtils.getUTC().startOfDay
        
        if everythingSent(maxDate) {
            TrackerLogger.d("No data to upload, already up to date")
        } else {
            
            isUploading = true
            
            let activities = TrackerTableActivities.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
            let locations = TrackerTableLocations.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
            let pedometers = TrackerTablePedometer.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
            let segments = TrackerTableSegments.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
            let summaries = TrackerTableSummaries.getNotSent(maxDateSummaries, TrackerConstants.DATA_UPLOAD_LIMIT)
            
            TrackerLogger.d("Data to upload" +
                "\n\(activities.count) activities" +
                "\n\(locations.count) locations" +
                "\n\(pedometers.count) pedometers" +
                "\n\(segments.count) segments" +
                "\n\(summaries.count) summaries"
            )
            
            var params = JSONDict()
            
            let userId = TrackerPreferences.user.id
            
            var requestData = generateData(activities, locations, summaries, pedometers, segments)
            requestData["userID"] = userId
            requestData["appSemanticVersion"] = "iPhone-\(TrackerUtils.getVersionName() ?? TrackerConstants.EMPTY)"
            params["data"] = requestData
            
            var config = JSONDict()
            config["sql"] = true
            config["mongo"] = true
            params["config"] = config
            
            let webservice = TrackerWebService<EmptyRequest>(.UPLOAD_DATA)
            webservice.method = .post
            webservice.paramsDict = params
            
            TrackerConnection(webservice, { tag, result, response in
                switch result {
                    case .SUCCESS:
                        let model: TrackerResponseMap? = TrackerGson.toObject(response!)
                        if model != nil {
                            if model!.error == true {
                                TrackerLogger.e("Upload data error")
                            } else {
                                TrackerLogger.d("Upload data success")
                                completeUpload(maxDate, activities, locations, summaries, pedometers, segments)
                            }
                        } else {
                            TrackerLogger.e("Upload data model is null")
                    }
                    case .ERROR:
                        TrackerLogger.e("Upload data error")
                    case .COMPLETED:
                        isUploading = false
                    default:
                        break
                }
            }).connect()
        }
    }
    
    fileprivate static func everythingSent(_ maxDate: Date) -> Bool {
        let activities = TrackerTableActivities.getNotSent(maxDate)
        let locations = TrackerTableLocations.getNotSent(maxDate)
        let pedometers = TrackerTablePedometer.getNotSent(maxDate)
        let segments = TrackerTableSegments.getNotSent(maxDate)
        let summaries = TrackerTableSummaries.getNotSent(maxDate)
        return activities.isEmpty && locations.isEmpty && pedometers.isEmpty && segments.isEmpty && summaries.isEmpty
    }
    
    fileprivate static func completeUpload(_ maxDate: Date, _ activities: [TrackerDBActivity], _ locations: [TrackerDBLocation], _ summaries: [TrackerDBSummary], _ pedometers: [TrackerDBPedometer], _ segments: [TrackerDBSegment]) {
        
        let lastDataUpload = TrackerTimeUtils.getCurrent()
        
        // mark data as sent
        for activity in activities { activity.sentToDB = lastDataUpload }
        for location in locations { location.sentToDB = lastDataUpload }
        for summary in summaries { summary.sentToDB = lastDataUpload }
        for pedometer in pedometers { pedometer.sentToDB = lastDataUpload }
        for segment in segments { segment.sentToDB = lastDataUpload }
        
        // update data
        TrackerTableActivities.upsert(activities)
        TrackerTableLocations.upsert(locations)
        TrackerTableSummaries.upsert(summaries)
        TrackerTablePedometer.upsert(pedometers)
        TrackerTableSegments.upsert(segments)
        
        if everythingSent(maxDate) {
            // remember last data upload
            TrackerPreferences.routine.lastDataUpload = lastDataUpload
        } else {
            // upload the remaining data
            uploadData()
        }
    }
    
    fileprivate static func generateData(_ activities: [TrackerDBActivity], _ locations: [TrackerDBLocation], _ summaries: [TrackerDBSummary], _ pedometers: [TrackerDBPedometer], _ segments: [TrackerDBSegment]) -> JSONDict {
        
        let activitiesArray: JSONArray = activities.map { activity -> JSONDict in
            var dic = JSONDict()
            dic["type"] = activity.activityType
            dic["confidence"] = activity.confidence
            dic["startDate"] = TrackerTimeUtils.format(activity.startDate, TrackerConstants.DATE_FORMAT_ISO_NO)
            dic["endDate"] = TrackerTimeUtils.format(activity.endDate, TrackerConstants.DATE_FORMAT_ISO_NO)
            return dic
        }
        
        let locationsArray: JSONArray = locations.map { location -> JSONDict in
            var dic = JSONDict()
            dic["timestamp"] = TrackerTimeUtils.format(location.date, TrackerConstants.DATE_FORMAT_ISO_NO)
            dic["latitude"] = location.latitude
            dic["longitude"] = location.longitude
            dic["accuracy"] = location.accuracy
            return dic
        }
        
        let summariesArray: JSONArray = summaries.map { summary -> JSONDict in
            let distanceWalking = summary.distanceWalking
            let distanceCycling = summary.distanceCycling
            let distanceAutomotive = summary.distanceAutomotive
            
            var dic = JSONDict()
            dic["timestamp"] = TrackerTimeUtils.format(summary.date, TrackerConstants.DATE_FORMAT_ISO_NO)
            dic["numberOfSteps"] = summary.numberOfSteps
            dic["floorsClimbed"] = summary.floorsClimbed
            dic["timeWalking"] = summary.timeWalking
            dic["timeRunning"] = summary.timeRunning
            dic["timeCycling"] = summary.timeCycling
            dic["timeOther"] = summary.timeOther
            dic["timeInVehicle"] = summary.timeAutomotive
            dic["timeBriskWalking"] = summary.briskWalking
            dic["totalDistanceWalked"] = distanceWalking
            dic["totalDistanceCycled"] = distanceCycling
            dic["totalDistanceDriven"] = distanceAutomotive
            dic["totalDistanceTravelled"] = distanceWalking + distanceCycling + distanceAutomotive
            return dic
        }
        
        let pedometersArray: JSONArray = pedometers.map { pedometer -> JSONDict in
            var dic = JSONDict()
            dic["timestamp"] = TrackerTimeUtils.format(pedometer.endDate, TrackerConstants.DATE_FORMAT_ISO_NO)
            dic["numberOfSteps"] = pedometer.numberOfSteps
            dic["floorsClimbed"] = pedometer.floorsClimbed
            return dic
        }
        
        let segmentsArray: JSONArray = segments.map { segment -> JSONDict in
            var dic = JSONDict()
            dic["type"] = segment.type
            dic["startDate"] = TrackerTimeUtils.format(segment.startDate, TrackerConstants.DATE_FORMAT_ISO_NO)
            dic["endDate"] = TrackerTimeUtils.format(segment.endDate, TrackerConstants.DATE_FORMAT_ISO_NO)
            dic["distanceTravelled"] = segment.distanceTravelled
            dic["numberOfBriskChunks"] = segment.numberOfBriskChunks
            dic["steps"] = segment.steps
            dic["userChanged"] = segment.userChanged
            return dic
        }
        
        var multiRequest = JSONDict()
        multiRequest["activities"] = activitiesArray
        multiRequest["locations"] = locationsArray
        multiRequest["summaries"] = summariesArray
        multiRequest["steps"] = pedometersArray
        multiRequest["segments"] = segmentsArray
        return multiRequest
    }
}
