//
//  OpenGistsRequest.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 22.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

class PublicReposRequest: BackendRequest {
    
    var endpoint: String {
        return "/repositories"
    }
    
    var method: NetworkClient.Method {
        return .get
    }
    
    var query: NetworkClient.QueryType {
        return .path
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: [String: String]? {
        return defaultRequestHeader()
    }
}
