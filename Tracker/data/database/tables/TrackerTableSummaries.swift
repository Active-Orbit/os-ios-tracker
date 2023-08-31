//
//  TrackerTableSummaries.swift
//  Tracker
//
//  Created by Omar Brugna on 02/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
* Utility class used to manage database summaries
*/
public class TrackerTableSummaries {
    
    public static func getAll(trackerDetached: Bool = true) -> [TrackerDBSummary] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSummary.self)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getById(_ summaryId: String, trackerDetached: Bool = true) -> TrackerDBSummary? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSummary.self).where {
            $0.summaryId == summaryId
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getByDate(_ date: Date, trackerDetached: Bool = true) -> TrackerDBSummary? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSummary.self).where {
            $0.date >= date.startOfDay && $0.date < date.endOfDay
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getLastSent(trackerDetached: Bool = true) -> TrackerDBSummary? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSummary.self).where {
            $0.sentToDB == nil
        }.sorted(byKeyPath: "date", ascending: false)
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getNotSent(_ maxDate: Date, _ limit: Int = TrackerConstants.INVALID, trackerDetached: Bool = true) -> [TrackerDBSummary] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSummary.self).where {
            $0.sentToDB == nil && $0.weekly != TrackerConstants.TRUE && $0.date < maxDate
        }.sorted(byKeyPath: "date", ascending: true)
        var models = trackerDetached ? results.trackerDetached : Array(results)
        if limit != TrackerConstants.INVALID { models = models.limitedTo(limit) }
        return models
    }
    
    public static func upsert(_ model: TrackerDBSummary) {
        upsert([model])
    }
    
    public static func upsert(_ models: [TrackerDBSummary]) {
        var updatedModels = [TrackerDBSummary]()
        for model in models {
            let oldModel = getById(model.summaryId)
            if oldModel?.sentToDB == nil || oldModel!.shouldBeUpdatedWith(model) {
                updatedModels.append(model)
            }
        }
        
        do {
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.add(updatedModels.trackerDetached(), update: .modified)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on upsert summaries to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(trackerDetached: false)
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on truncate summaries from database \(error.localizedDescription)")
        }
    }
}
