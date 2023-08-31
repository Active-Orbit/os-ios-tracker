//
//  TrackerGson.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class TrackerGson {
    
    public static func toJsonData<T : Encodable>(_ encodable: T) -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(encodable)
        } catch {
            TrackerLogger.e("Error on json encoding \(error.localizedDescription)")
        }
        return nil
    }
    
    public static func toJsonString<T : Encodable>(_ encodable: T) -> String? {
        let jsonData = toJsonData(encodable)
        if jsonData != nil {
            return String(data: jsonData!, encoding: .utf8)
        }
        return nil
    }
    
    public static func toObject<T : Decodable>(_ json: String) -> T? {
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: Data(json.utf8))
        } catch {
            TrackerLogger.e("Error on json decoding \(error.localizedDescription)")
        }
        return nil
    }
    
    public static func toArray<T : Decodable>(_ json: String) -> [T]? {
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode([T].self, from: Data(json.utf8))
        } catch {
            TrackerLogger.e("Error on json decoding \(error.localizedDescription)")
        }
        return nil
    }
}

extension Collection where Iterator.Element == JSONDict {
    
    func toJson(_ options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        var json = "[]"
        if self is JSONArray {
            let data = try? JSONSerialization.data(withJSONObject: self as! JSONArray, options: options)
            let string = String(data: data!, encoding: .utf8)
            if !TrackerTextUtils.isEmpty(string) { json = string! }
        }
        return json
    }
}
