//
//  BatteriesUploader.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class BatteriesUploader {
    
    private static var isUploading = false
    
    internal static func uploadData(_ listener: TrackerClosureBool? = nil) {
        listener?(true)
        // TODO
        /*
        if isUploading {
            TrackerLogger.d("Batteries upload already in progress")
            listener?(false)
            return
        }
        
        let maxDate = TrackerTimeUtils.getUTC()
        
        let models = TrackerTableBatteries.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
        if models.isEmpty {
            TrackerLogger.d("No batteries to upload on server")
            listener?(false)
            return
        }
        
        isUploading = true
        
        let request = BatteriesRequest()
        request.userId = TrackerPreferences.user.id ?? TrackerConstants.EMPTY
        
        for model in models {
            let modelRequest = BatteriesRequest.BatteryRequest(model)
            request.batteries.append(modelRequest)
        }
        
        let webservice = TrackerWebService<BatteriesRequest>(.INSERT_BATTERIES)
        webservice.method = .post
        webservice.params = request
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: UploadLocationsMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model?.isValid() == true {
                            if model!.inserted! >= models.count {
                                TrackerLogger.d("Batteries uploaded to server \(model!.inserted!) success")
                                // mark batteries as uploaded
                                models.forEach({ $0.sentToDB = TrackerTimeUtils.getCurrent() })
                                TrackerTableBatteries.upsert(models)
                                isUploading = false
                                listener?(true)
                            } else {
                                TrackerLogger.d("Batteries uploaded to server error \(model!.inserted!) success")
                                isUploading = false
                                listener?(false)
                            }
                        } else {
                            TrackerLogger.e("Batteries uploaded to server invalid")
                            isUploading = false
                            listener?(false)
                        }
                    } else {
                        TrackerLogger.e("Error parsing batteries json response")
                        isUploading = false
                        listener?(false)
                    }
                case .ERROR:
                    TrackerLogger.e("Error uploading batteries to server")
                    isUploading = false
                    listener?(false)
                default:
                    break
            }
        }).connect()
        */
    }
}
