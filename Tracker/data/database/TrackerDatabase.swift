//
//  TrackerDatabase.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

internal class TrackerDatabase {
    
    internal static let instance = TrackerDatabase()
    internal var database: Realm!
    
    init() {
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.objectTypes = [TrackerDBActivity.self, TrackerDBBriskWalking.self, TrackerDBLocation.self, TrackerDBPedometer.self , TrackerDBSegment.self, TrackerDBSummary.self]
        config.encryptionKey = Data(base64Encoded: TrackerConstants.DATABASE_ENCRYPTION_KEY)
        
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                // Realm will automatically detect the added and removed properties
            }
        }
        
        do {
            database = try Realm(configuration: config)
        } catch {
            TrackerLogger.e("Error initializing database \(error.localizedDescription)")
        }
    }
    
    internal func beginWrite() {
        if !database.isInWriteTransaction {
            database.beginWrite()
        }
    }
    
    internal func commitWrite() throws {
        if database.isInWriteTransaction {
            try database.commitWrite()
        } else {
            TrackerLogger.e("Commit write while not in a write transaction")
        }
    }
    
    internal func logout() {
        do {
            try database.write {
                database.deleteAll()
            }
        } catch {
            TrackerLogger.e("Error trying to clear database \(error.localizedDescription)")
        }
    }
}
