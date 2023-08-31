//
//  TrackerTableSegments.swift
//  Tracker
//
//  Created by Omar Brugna on 02/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
* Utility class used to manage database segments
*/
public class TrackerTableSegments {
    
    public static func getAll(trackerDetached: Bool = true) -> [TrackerDBSegment] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSegment.self)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func getById(_ segmentId: String, trackerDetached: Bool = true) -> TrackerDBSegment? {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSegment.self).where {
            $0.segmentId == segmentId
        }
        if results.isEmpty {
            return nil
        }
        return trackerDetached ? results[0].trackerDetached() : results[0]
    }
    
    public static func getBetween(_ fromDate: Date, _ toDate: Date, trackerDetached: Bool = true) -> [TrackerDBSegment] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSegment.self).where {
            $0.startDate >= fromDate && $0.endDate < toDate
        }.sorted(byKeyPath: "startDate", ascending: true)
        let models = trackerDetached ? results.trackerDetached : Array(results)
        return models
    }
    
    public static func deleteBetween(_ fromDate: Date, _ toDate: Date) {
        do {
            let models = TrackerDatabase.instance.database.objects(TrackerDBSegment.self).where {
                $0.startDate >= fromDate && $0.endDate < toDate
            }
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on delete segments between \(TrackerTimeUtils.log(fromDate)) and \(TrackerTimeUtils.log(toDate)) from database \(error.localizedDescription)")
        }
    }
    
    public static func getNotSent(_ maxDate: Date, _ limit: Int = TrackerConstants.INVALID, trackerDetached: Bool = true) -> [TrackerDBSegment] {
        let results = TrackerDatabase.instance.database.objects(TrackerDBSegment.self).where {
            $0.sentToDB == nil && $0.endDate < maxDate
        }.sorted(byKeyPath: "startDate", ascending: true)
        var models = trackerDetached ? results.trackerDetached : Array(results)
        if limit != TrackerConstants.INVALID { models = models.limitedTo(limit) }
        return models
    }
    
    public static func upsert(_ model: TrackerDBSegment) {
        upsert([model])
    }
    
    public static func upsert(_ models: [TrackerDBSegment]) {
        var updatedModels = [TrackerDBSegment]()
        for model in models {
            let oldModel = getById(model.segmentId)
            if oldModel?.sentToDB == nil || oldModel!.shouldBeUpdatedWith(model) {
                updatedModels.append(model)
            }
        }
        
        do {
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.add(updatedModels.trackerDetached(), update: .modified)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on upsert segments to database \(error.localizedDescription)")
        }
    }
    
    public static func delete(_ model: TrackerDBSegment) {
        do {
            let attachedModel = getById(model.segmentId, trackerDetached: false)
            if attachedModel != nil {
                TrackerDatabase.instance.beginWrite()
                TrackerDatabase.instance.database.delete(attachedModel!)
                try TrackerDatabase.instance.commitWrite()
            } else {
                TrackerLogger.e("Trying to delete a segment with id \(model.segmentId) that is not found in database")
            }
        } catch {
            TrackerLogger.e("Error on delete segment \(model.segmentId) from database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(trackerDetached: false)
            TrackerDatabase.instance.beginWrite()
            TrackerDatabase.instance.database.delete(models)
            try TrackerDatabase.instance.commitWrite()
        } catch {
            TrackerLogger.e("Error on truncate segments from database \(error.localizedDescription)")
        }
    }
}
