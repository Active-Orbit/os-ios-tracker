//
//  TrackerConnection.swift
//  Tracker
//
//  Created by Omar Brugna on 03/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Alamofire

internal class TrackerConnection<T: BaseRequest> {
    
    fileprivate var request: DataRequest?
    
    internal var tag = TrackerConstants.INVALID
    
    public var webService: TrackerWebService<T>!
    internal var listener: TrackerClosureConnection!
    
    internal var isOverridden = false
    internal var isRunning = false
    
    fileprivate var timeoutExtendedLocal = false
    internal func timeoutExtended(_ boolean: Bool) -> TrackerConnection {
        timeoutExtendedLocal = boolean
        return self
    }
    
    fileprivate var sessionManager: Session!
    
    // MARK: init methods
    
    internal init(_ webService: TrackerWebService<T>, _ listener: @escaping TrackerClosureConnection) {
        self.webService = webService
        self.listener = listener
    }
    
    // MARK: starts methods
    
    internal func connect() {
        DispatchQueue.global(qos: .background).async {
            self.initConnection()
        }
    }
    
    fileprivate func initConnection() {
        DispatchQueue.main.async {
            self.listener(self.tag, .STARTED, nil)
        }
        
        startConnection({ response in
            if response != nil {
                TrackerLogger.i("Connection response [\(self.webService.api.apiUrl)]:" + response!)
                DispatchQueue.main.async {
                    self.listener(self.tag, .SUCCESS, response)
                }
            } else {
                TrackerLogger.w("Connection response [\(self.webService.api.apiUrl)] is null")
                DispatchQueue.main.async {
                    self.listener(self.tag, .ERROR, nil)
                }
            }
            
            DispatchQueue.main.async {
                // always notify completed request
                self.listener(self.tag, .COMPLETED, nil)
                self.isRunning = false
            }
        })
    }
    
    fileprivate func startConnection(_ responseListener: @escaping (String?) -> ()) {
        
        var headers = HTTPHeaders()
        if !TrackerTextUtils.isEmpty(webService.contentType) {
            headers[TrackerNetwork.CONTENT_TYPE] = webService.contentType
        }
        if !TrackerTextUtils.isEmpty(webService.connection) {
            headers[TrackerNetwork.CONNECTION] = webService.connection
        }
        if !TrackerTextUtils.isEmpty(webService.cacheControl) {
            headers[TrackerNetwork.CACHE_CONTROL] = webService.cacheControl
        }
        
        // configurations
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutExtendedLocal ? TrackerNetwork.CONNECTION_TIMEOUT_EXTENDED : TrackerNetwork.CONNECTION_TIMEOUT
        configuration.timeoutIntervalForResource = timeoutExtendedLocal ? TrackerNetwork.SOCKET_TIMEOUT_EXTENDED : TrackerNetwork.SOCKET_TIMEOUT
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.headers = headers
        sessionManager = Session(configuration: configuration)
        
        isRunning = true
        
        if webService.paramsDict != nil {
            request = sessionManager.request(webService.url!, method: webService.method, parameters: webService.paramsDict, encoding: webService.encodingDict, headers: headers)
        } else if webService.params != nil {
            request = sessionManager.request(webService.url!, method: webService.method, parameters: webService.params, encoder: webService.encoding, headers: headers, interceptor: nil, requestModifier: nil)
        } else {
            request = sessionManager.request(webService.url!, method: webService.method, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil)
        }
        
        request!.responseString(completionHandler: { response in
            guard !self.isOverridden else {
                TrackerLogger.w("Connection [\(self.webService.api.apiUrl)] has been overridden")
                self.isRunning = false
                return
            }
            
            var paramsString = TrackerConstants.EMPTY
            if self.webService.paramsDict != nil {
                paramsString = self.webService.paramsDict!.debugDescription
            } else {
                paramsString = self.webService.params?.toJson() ?? "null"
            }
            var requestBody = TrackerConstants.EMPTY
            if response.request?.httpBody != nil {
                requestBody = String(data: response.request!.httpBody!, encoding: .utf8) ?? TrackerConstants.EMPTY
            }
            TrackerLogger.d("Connection" +
                "\nUrl: " + self.webService.urlString +
                "\nTimeout: " + (self.timeoutExtendedLocal ? "Extended" : "Normal") +
                "\nParams: " + paramsString +
                "\nRequest: " + requestBody
            )
            
            switch response.result {
            case .success(let value):
                responseListener(value)
            case .failure(let error):
                TrackerLogger.e("Unexpected HTTP response: " + error.localizedDescription)
                responseListener(nil)
            }
        })
    }
    
    // MARK: utility methods
    
    internal func cancel() {
        request?.cancel()
    }
}
