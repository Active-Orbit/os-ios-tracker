//
//  TrackerTableActivities.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
* Utility class used to manage database activities
*/
public class TrackerTableActivities {
    
    public static func getAll(trackerDetached: Bool = true) -> [TrackerDBActivity] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBActivity.self).sorted(byKeyPath: "startDate", ascending: true)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getById(_ activityId: String, trackerDetached: Bool = true) -> TrackerDBActivity? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBActivity.self).where {
            $0.activityId == activityId
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getBetween(_ fromDate: Date, _ toDate: Date, trackerDetached: Bool = true) -> [TrackerDBActivity] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBActivity.self).where {
            $0.startDate >= fromDate && $0.endDate < toDate
        }.sorted(byKeyPath: "startDate", ascending: true)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func deleteBetween(_ fromDate: Date, _ toDate: Date) {
        do {
            let models = TrackerDatabase.instance.database.objects(TrackerDBActivity.self).where {
                $0.startDate >= fromDate && $0.endDate < toDate
            }
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on delete activities between \(TrackerTimeUtils.log(fromDate)) and \(TrackerTimeUtils.log(toDate)) from database \(error.localizedDescription)")
        }
    }
    
    public static func getNotAnalysed(trackerDetached: Bool = true) -> [TrackerDBActivity] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBActivity.self).where {
            $0.analysed == TrackerConstants.FALSE
        }.sorted(byKeyPath: "startDate", ascending: true)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getNotSent(_ maxDate: Date, _ limit: Int = TrackerConstants.INVALID, trackerDetached: Bool = true) -> [TrackerDBActivity] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBActivity.self).where {
            $0.sentToDB == nil && $0.endDate < maxDate
        }.sorted(byKeyPath: "startDate", ascending: true)
        var models = trackerDetached ? results.trackerDetached : Array(results)
        if limit != TrackerConstants.INVALID { models = models.limitedTo(limit) }
        return models
    }
    
    public static func upsert(_ model: TrackerDBActivity) {
        upsert([model])
    }
    
    public static func upsert(_ models: [TrackerDBActivity]) {
        var updatedModels = [TrackerDBActivity]()
        for model in models {
            let oldModel = getById(model.activityId)
            if oldModel?.sentToDB == nil || oldModel!.shouldBeUpdatedWith(model) {
                updatedModels.append(model)
            }
        }
        
        do {
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.add(updatedModels.trackerDetached(), update: .modified)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on upsert activities to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(trackerDetached: false)
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on truncate activities from database \(error.localizedDescription)")
        }
    }
}
