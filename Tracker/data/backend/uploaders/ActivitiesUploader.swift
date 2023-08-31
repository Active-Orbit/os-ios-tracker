//
//  ActivitiesUploader.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class ActivitiesUploader {
    
    private static var isUploading = false
    
    internal static func uploadData(_ listener: TrackerClosureBool? = nil) {
        if isUploading {
            TrackerLogger.d("Activities upload already in progress")
            listener?(false)
            return
        }
        
        let maxDate = TrackerTimeUtils.getUTC()
        
        let models = TrackerTableActivities.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
        if models.isEmpty {
            TrackerLogger.d("No activities to upload on server")
            listener?(false)
            return
        }
        
        isUploading = true
        
        let request = ActivitiesRequest()
        request.userId = TrackerPreferences.user.id ?? TrackerConstants.EMPTY
        
        for model in models {
            let modelRequest = ActivitiesRequest.ActivityRequest(model)
            request.activities.append(modelRequest)
        }
        
        let webservice = TrackerWebService<ActivitiesRequest>(.INSERT_ACTIVITIES)
        webservice.method = .post
        webservice.params = request
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: UploadLocationsMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model?.isValid() == true {
                            if model!.inserted! >= models.count {
                                TrackerLogger.d("Activities uploaded to server \(model!.inserted!) success")
                                // mark activities as uploaded
                                models.forEach({ $0.sentToDB = TrackerTimeUtils.getCurrent() })
                                TrackerTableActivities.upsert(models)
                                isUploading = false
                                listener?(true)
                            } else {
                                TrackerLogger.d("Activities uploaded to server error \(model!.inserted!) success")
                                isUploading = false
                                listener?(false)
                            }
                        } else {
                            TrackerLogger.e("Activities uploaded to server invalid")
                            isUploading = false
                            listener?(false)
                        }
                    } else {
                        TrackerLogger.e("Error parsing activities json response")
                        isUploading = false
                        listener?(false)
                    }
                case .ERROR:
                    TrackerLogger.e("Error uploading activities to server")
                    isUploading = false
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
}
