//
//  TrackerTableBriskWalking.swift
//  Tracker
//
//  Created by Omar Brugna on 02/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
* Utility class used to manage database brisk walking
*/
public class TrackerTableBriskWalking {
    
    public static func getAll(trackerDetached: Bool = true) -> [TrackerDBBriskWalking] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBBriskWalking.self)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getById(_ briskWalkingId: String, trackerDetached: Bool = true) -> TrackerDBBriskWalking? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBBriskWalking.self).where {
            $0.briskWalkingId == briskWalkingId
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func upsert(_ model: TrackerDBBriskWalking) {
        upsert([model])
    }
    
    public static func upsert(_ models: [TrackerDBBriskWalking]) {
        do {
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.add(models.trackerDetached(), update: .modified)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on upsert brisk walking to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(trackerDetached: false)
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on truncate brisk walking from database \(error.localizedDescription)")
        }
    }
}
