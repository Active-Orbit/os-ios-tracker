//
//  TrackerTablePedometer.swift
//  Tracker
//
//  Created by Omar Brugna on 02/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Utility class used to manage database pedometer data
 */
public class TrackerTablePedometer {
    
    public static func getAll(trackerDetached: Bool = true) -> [TrackerDBPedometer] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBPedometer.self)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getById(_ pedometerId: String, trackerDetached: Bool = true) -> TrackerDBPedometer? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBPedometer.self).where {
            $0.pedometerId == pedometerId
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getNotSent(_ maxDate: Date, _ limit: Int = TrackerConstants.INVALID, trackerDetached: Bool = true) -> [TrackerDBPedometer] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBPedometer.self).where {
            $0.sentToDB == nil && $0.endDate < maxDate
        }.sorted(byKeyPath: "startDate", ascending: true)
        var models = trackerDetached ? results.trackerDetached : Array(results)
        if limit != TrackerConstants.INVALID { models = models.limitedTo(limit) }
        return models
    }
    
    public static func upsert(_ model: TrackerDBPedometer) {
        upsert([model])
    }
    
    public static func upsert(_ models: [TrackerDBPedometer]) {
        var updatedModels = [TrackerDBPedometer]()
        for model in models {
            let oldModel = getById(model.pedometerId)
            if oldModel?.sentToDB == nil || oldModel!.shouldBeUpdatedWith(model) {
                updatedModels.append(model)
            }
        }
        
        do {
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.add(updatedModels.trackerDetached(), update: .modified)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on upsert pedometer to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(trackerDetached: false)
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on truncate pedometer from database \(error.localizedDescription)")
        }
    }
}
