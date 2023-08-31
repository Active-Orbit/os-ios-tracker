//
//  LocationsUploader.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class LocationsUploader {
    
    private static var isUploading = false
    
    internal static func uploadData(_ listener: TrackerClosureBool? = nil) {
        if isUploading {
            TrackerLogger.d("Locations upload already in progress")
            listener?(false)
            return
        }
        
        let maxDate = TrackerTimeUtils.getUTC()
        
        let models = TrackerTableLocations.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
        if models.isEmpty {
            TrackerLogger.d("No locations to upload on server")
            listener?(false)
            return
        }
        
        isUploading = true
        
        let request = LocationsRequest()
        request.userId = TrackerPreferences.user.id ?? TrackerConstants.EMPTY
        
        for model in models {
            let modelRequest = LocationsRequest.LocationRequest(model)
            request.locations.append(modelRequest)
        }
        
        let webservice = TrackerWebService<LocationsRequest>(.INSERT_LOCATIONS)
        webservice.method = .post
        webservice.params = request
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: UploadLocationsMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model?.isValid() == true {
                            if model!.inserted! >= models.count {
                                TrackerLogger.d("Locations uploaded to server \(model!.inserted!) success")
                                // mark locations as uploaded
                                models.forEach({ $0.sentToDB = TrackerTimeUtils.getCurrent() })
                                TrackerTableLocations.upsert(models)
                                isUploading = false
                                listener?(true)
                            } else {
                                TrackerLogger.d("Locations uploaded to server error \(model!.inserted!) success")
                                isUploading = false
                                listener?(false)
                            }
                        } else {
                            TrackerLogger.e("Locations uploaded to server invalid")
                            isUploading = false
                            listener?(false)
                        }
                    } else {
                        TrackerLogger.e("Error parsing locations json response")
                        isUploading = false
                        listener?(false)
                    }
                case .ERROR:
                    TrackerLogger.e("Error uploading locations to server")
                    isUploading = false
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
}
