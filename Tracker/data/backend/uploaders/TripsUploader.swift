//
//  TripsUploader.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class TripsUploader {
    
    private static var isUploading = false
    
    internal static func uploadData(_ listener: TrackerClosureBool? = nil) {
        if isUploading {
            TrackerLogger.d("Trips upload already in progress")
            listener?(false)
            return
        }
        
        let maxDateMidnight = TrackerTimeUtils.getUTC().startOfDay
        
        let models = TrackerTableSegments.getNotSent(maxDateMidnight, TrackerConstants.DATA_UPLOAD_LIMIT)
        if models.isEmpty {
            TrackerLogger.d("No trips to upload on server")
            listener?(false)
            return
        }
        
        isUploading = true
        
        let request = TripsRequest()
        request.userId = TrackerPreferences.user.id ?? TrackerConstants.EMPTY
        
        for model in models {
            let modelRequest = TripsRequest.TripRequest(model)
            request.trips.append(modelRequest)
        }
        
        let webservice = TrackerWebService<TripsRequest>(.INSERT_TRIPS)
        webservice.method = .post
        webservice.params = request
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: UploadLocationsMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model?.isValid() == true {
                            if model!.inserted! >= models.count {
                                TrackerLogger.d("Trips uploaded to server \(model!.inserted!) success")
                                // mark trips as uploaded
                                models.forEach({ $0.sentToDB = TrackerTimeUtils.getCurrent() })
                                TrackerTableSegments.upsert(models)
                                isUploading = false
                                listener?(true)
                            } else {
                                TrackerLogger.d("Trips uploaded to server error \(model!.inserted!) success")
                                isUploading = false
                                listener?(false)
                            }
                        } else {
                            TrackerLogger.e("Trips uploaded to server invalid")
                            isUploading = false
                            listener?(false)
                        }
                    } else {
                        TrackerLogger.e("Error parsing trips json response")
                        isUploading = false
                        listener?(false)
                    }
                case .ERROR:
                    TrackerLogger.e("Error uploading trips to server")
                    TrackerLogger.e("Error uploading trips to server")
                    isUploading = false
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
}
