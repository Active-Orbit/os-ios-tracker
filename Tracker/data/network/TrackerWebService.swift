//
//  TrackerWebService.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import Alamofire

/**
 * Class used to build a web service with url and params
 */
internal class TrackerWebService<T : BaseRequest> {
    
    fileprivate var baseUrl = TrackerPreferences.backend.baseUrl
    
    internal var method = HTTPMethod.get
    internal var encoding: ParameterEncoder = JSONParameterEncoder.default
    internal var urlString = TrackerConstants.EMPTY
    
    internal var contentType = TrackerNetwork.CONTENT_TYPE_APPLICATION_JSON
    internal var connection = TrackerNetwork.KEEP_ALIVE
    internal var cacheControl = TrackerNetwork.NO_CACHE
    
    internal var headers = [String : String]()
    
    internal var api: TrackerApi
    internal var params: T?
    
    internal var paramsDict: [String : Any]?
    internal var encodingDict: ParameterEncoding = JSONEncoding.default
    
    /**
     * Return the URL object that represent the TrackerWebService
     */
    internal var url: URL? {
        get {
            return URL(string: urlString)
        }
    }
    
    convenience init(_ url: String, _ params: T? = nil) {
        self.init(.EMPTY, params)
        urlString = url
    }
    
    init(_ api: TrackerApi, _ params: T? = nil) {
        self.api = api
        self.params = params
        self.urlString = "\(TrackerPreferences.backend.baseUrl)/\(api.apiUrl)"
    }
}
