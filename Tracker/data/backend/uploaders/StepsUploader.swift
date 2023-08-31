//
//  StepsUploader.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

internal class StepsUploader {
    
    private static var isUploading = false
    
    internal static func uploadData(_ listener: TrackerClosureBool? = nil) {
        if isUploading {
            TrackerLogger.d("Steps upload already in progress")
            listener?(false)
            return
        }
        
        let maxDate = TrackerTimeUtils.getUTC()
        
        let models = TrackerTablePedometer.getNotSent(maxDate, TrackerConstants.DATA_UPLOAD_LIMIT)
        if models.isEmpty {
            TrackerLogger.d("No steps to upload on server")
            listener?(false)
            return
        }
        
        isUploading = true
        
        let request = StepsRequest()
        request.userId = TrackerPreferences.user.id ?? TrackerConstants.EMPTY
        
        for model in models {
            let modelRequest = StepsRequest.StepRequest(model)
            request.steps.append(modelRequest)
        }
        
        let webservice = TrackerWebService<StepsRequest>(.INSERT_STEPS)
        webservice.method = .post
        webservice.params = request
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: UploadLocationsMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model?.isValid() == true {
                            if model!.inserted! >= models.count {
                                TrackerLogger.d("Steps uploaded to server \(model!.inserted!) success")
                                // mark steps as uploaded
                                models.forEach({ $0.sentToDB = TrackerTimeUtils.getCurrent() })
                                TrackerTablePedometer.upsert(models)
                                isUploading = false
                                listener?(true)
                            } else {
                                TrackerLogger.d("Steps uploaded to server error \(model!.inserted!) success")
                                isUploading = false
                                listener?(false)
                            }
                        } else {
                            TrackerLogger.e("Steps uploaded to server invalid")
                            isUploading = false
                            listener?(false)
                        }
                    } else {
                        TrackerLogger.e("Error parsing steps json response")
                        isUploading = false
                        listener?(false)
                    }
                case .ERROR:
                    TrackerLogger.e("Error uploading steps to server")
                    isUploading = false
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
}
