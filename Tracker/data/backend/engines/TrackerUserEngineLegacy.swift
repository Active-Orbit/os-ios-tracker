//
//  TrackerUserEngineLegacy.swift
//  Tracker
//
//  Created by Omar Brugna on 31/05/2023.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import UIKit

internal class TrackerUserEngineLegacy {
    
    internal static func registerUser() {
        guard TrackerTextUtils.isEmpty(TrackerPreferences.user.id) else {
            // user already registered
            TrackerLogger.d("User already registered with id \(TrackerPreferences.user.id!)")
            return
        }
        
        let phoneModel = UIDevice.current.modelName + ", " + UIDevice.current.systemVersionString
        let targetApp = TrackerPreferences.backend.targetApp.id
        let params = [
            "user": [
                "phoneModel": phoneModel,
                "app_type": targetApp,
                "appSemanticVersion": "iPhone-\(TrackerUtils.getVersionName() ?? TrackerConstants.EMPTY)"
            ] as [String : Any]
        ]
        
        let webservice = TrackerWebService<EmptyRequest>(.USER_SIGNUP)
        webservice.method = .post
        webservice.paramsDict = params
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: TrackerUserMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model!.error == true || TrackerTextUtils.isEmpty(model?.userID) {
                            TrackerLogger.e("User registration error from model")
                        } else {
                            TrackerPreferences.user.id = model!.userID!
                            TrackerLogger.d("User registration success with user id \(model!.userID!)")
                        }
                    } else {
                        TrackerLogger.e("User registration model is null")
                    }
                case .ERROR:
                    TrackerLogger.e("User registration error")
                default:
                    break
            }
        }).connect()
    }
    
    internal static func updateUser(_ forced: Bool = false) {
        guard !TrackerTextUtils.isEmpty(TrackerPreferences.user.id) else {
            // user is not registered
            TrackerLogger.d("User update cancelled because the user is not registered yet")
            TrackerApiManager.registerUser()
            return
        }
        
        if !forced {
            let lastUserUpdate = TrackerPreferences.routine.lastUserUpdate
            if lastUserUpdate != nil && TrackerTimeUtils.getCurrent().hoursFrom(lastUserUpdate!) < TrackerConstants.USER_UPDATE_FREQUENCY_HOURS {
                // too early to send data
                return
            }
        }
        
        let phoneModel = UIDevice.current.modelName + ", " + UIDevice.current.systemVersionString
        let targetApp = TrackerPreferences.backend.targetApp.id
        let params = [
            "user": [
                "id": TrackerPreferences.user.id!,
                "phoneModel": phoneModel,
                "app_type": targetApp,
                "appSemanticVersion": "iPhone-\(TrackerUtils.getVersionName() ?? TrackerConstants.EMPTY)"
            ] as [String : Any]
        ]
        
        let webservice = TrackerWebService<EmptyRequest>(.USER_UPDATE)
        webservice.method = .post
        webservice.paramsDict = params
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: TrackerUserMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model!.error == true {
                            TrackerLogger.e("User update error from model")
                        } else {
                            TrackerLogger.d("User update success")
                            
                            // remember last update
                            TrackerPreferences.routine.lastUserUpdate = TrackerTimeUtils.getCurrent()
                        }
                    } else {
                        TrackerLogger.e("User update model is null")
                }
                case .ERROR:
                    TrackerLogger.e("User update error")
                default:
                    break
            }
        }).connect()
    }
    
    internal static func updateUserPushToken() {
        guard !TrackerTextUtils.isEmpty(TrackerPreferences.user.id) else {
            // user is not registered
            TrackerLogger.d("User update push token cancelled because the user is not registered yet")
            return
        }
        
        guard !TrackerTextUtils.isEmpty(TrackerPreferences.user.pushToken) else {
            // user push token is null or empty
            TrackerLogger.d("User update push token cancelled because the user push token is null or empty")
            return
        }
        
        let params = [
            "user": [
                "id": TrackerPreferences.user.id!,
                "firebaseToken": TrackerPreferences.user.pushToken!
            ]
        ]
        
        let webservice = TrackerWebService<EmptyRequest>(.USER_UPDATE_PUSH_TOKEN)
        webservice.method = .post
        webservice.paramsDict = params
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: TrackerUserMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model!.error == true {
                            TrackerLogger.e("User update push token error from model")
                        } else {
                            TrackerLogger.d("User update push token success")
                        }
                    } else {
                        TrackerLogger.e("User update push token model is null")
                }
                case .ERROR:
                    TrackerLogger.e("User update push token error")
                default:
                    break
            }
        }).connect()
    }
}
