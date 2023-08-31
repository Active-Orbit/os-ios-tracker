//
//  TrackerTableLocations.swift
//  Tracker
//
//  Created by Omar Brugna on 02/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
* Utility class used to manage database locations
*/
public class TrackerTableLocations {
    
    public static func getAll(trackerDetached: Bool = true) -> [TrackerDBLocation] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBLocation.self)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getById(_ locationId: String, trackerDetached: Bool = true) -> TrackerDBLocation? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBLocation.self).where {
            $0.locationId == locationId
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getBetween(_ fromDate: Date, _ toDate: Date, trackerDetached: Bool = true) -> [TrackerDBLocation] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBLocation.self).where {
            $0.date >= fromDate && $0.date < toDate
        }.sorted(byKeyPath: "date", ascending: true)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getNotSent(_ maxDate: Date, _ limit: Int = TrackerConstants.INVALID, trackerDetached: Bool = true) -> [TrackerDBLocation] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBLocation.self).where {
            $0.sentToDB == nil && $0.date < maxDate
        }.sorted(byKeyPath: "date", ascending: true)
        var models = trackerDetached ? results.trackerDetached : Array(results)
        if limit != TrackerConstants.INVALID { models = models.limitedTo(limit) }
        return models
    }
    
    public static func upsert(_ model: TrackerDBLocation) {
        upsert([model])
    }
    
    public static func upsert(_ models: [TrackerDBLocation]) {
        var updatedModels = [TrackerDBLocation]()
        for model in models {
            let oldModel = getById(model.locationId)
            if oldModel?.sentToDB == nil || oldModel!.shouldBeUpdatedWith(model) {
                updatedModels.append(model)
            }
        }
        
        do {
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.add(updatedModels.trackerDetached(), update: .modified)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on upsert locations to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(trackerDetached: false)
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on truncate locations from database \(error.localizedDescription)")
        }
    }
}
