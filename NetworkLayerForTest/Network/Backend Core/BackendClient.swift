//
//  BackendClient.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 22.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

public let DidPerformUnauthorizedOperation = "DidPerformUnauthorizedOperation"

class BackendClient {
    
    private let configuration: BackendConfiguration
    private let networkClient = NetworkClient()
    
    init (configuration: BackendConfiguration) {
        self.configuration = configuration
    }
    
    func request(_ request: BackendRequest,
                 success: ((Data?) -> Void)? = nil,
                 failure: ((Error) -> Void)? = nil) {
        
        let url = configuration.baseURL.appendingPathComponent(request.endpoint)
        
        let headers = request.headers
        
        networkClient.makeRequest(for: url, method: request.method, query: request.query, params: request.parameters, headers: headers, success: { data in
//            var json: AnyObject? = nil
//            if let data = data {
//                json = try? JSONSerialization.jsonObject(with: data as Data, options: []) as AnyObject
//            }
            success?(data)
            
        }, failure: { data, error, statusCode in
            if statusCode == 401 {
                // Operation not authorized
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DidPerformUnauthorizedOperation), object: nil)
                return
            }
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data as Data, options: []) as AnyObject
                let info = [
                    NSLocalizedDescriptionKey: json?["error"] as? String ?? "",
                    NSLocalizedFailureReasonErrorKey: "Probably not allowed action."
                ]
                let error = NSError(domain: "BackendService", code: 0, userInfo: info)
                failure?(error)
            } else {
                failure?(error ?? NSError(domain: "BackendService", code: 0, userInfo: nil))
            }
        })
    }
}
