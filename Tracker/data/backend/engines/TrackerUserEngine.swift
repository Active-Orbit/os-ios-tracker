//
//  TrackerUserEngine.swift
//  Tracker
//
//  Created by Omar Brugna on 11/05/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import UIKit

internal class TrackerUserEngine {
    
    internal static func registerUser(_ listener: TrackerClosureBool? = nil) {
        guard TrackerTextUtils.isEmpty(TrackerPreferences.user.id) else {
            // user already registered
            TrackerLogger.d("User already registered with id \(TrackerPreferences.user.id!)")
            return
        }
        
        let request = UserRegistrationRequest()
        request.phoneModel = TrackerUtils.getPhoneModel()
        request.appVersion = TrackerUtils.getAppVersion()
        request.androidVersion = TrackerUtils.getIosVersion()
        request.idProgram = "62f6402ccbdb315cd3fe32b7" // TODO
        request.idPatient = "0000000099" // TODO
        request.userSex = "Male" // TODO
        request.userAge = "33" // TODO
        request.userWeight = "70" // TODO
        request.userHeight = "175" // TODO
        request.batteryLevel = TrackerUtils.getBatteryPercentage()
        request.isCharging = TrackerUtils.isCharging()
        request.registrationTimestamp = TrackerTimeUtils.getCurrent().timeInMillis
        
        if !request.isValid() {
            TrackerLogger.e("Invalid user registration request")
            listener?(false)
            return
        }
        
        let webservice = TrackerWebService<UserRegistrationRequest>(.USER_REGISTRATION)
        webservice.method = .post
        webservice.params = request
        
        TrackerConnection(webservice, { tag, result, response in
            switch result {
                case .SUCCESS:
                    let model: UserRegistrationMap? = TrackerGson.toObject(response!)
                    if model != nil {
                        if model?.isValid() == true {
                            TrackerPreferences.user.id = model!.id
                            TrackerLogger.d("User registration success with user id \(model!.id!)")
                            listener?(true)
                        } else {
                            TrackerLogger.e("User registration to server invalid")
                            listener?(false)
                        }
                    } else {
                        TrackerLogger.e("Error parsing user registration json response")
                        listener?(false)
                    }
                case .ERROR:
                    TrackerLogger.e("Error user registration to server")
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
}
