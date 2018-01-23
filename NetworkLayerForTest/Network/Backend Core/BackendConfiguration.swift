//
//  BackendConfiguration.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 22.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

class BackendConfiguration {
    
    let baseURL: URL
    
    init (baseURL: URL) {
        self.baseURL = baseURL
    }
    
}

extension BackendConfiguration {
    
    static func gitHubConfiguration() -> BackendConfiguration {
        guard let url = URL(string: "https://api.github.com") else {
            fatalError("Wrong url string for BackendConfiguration")
        }
        let conf = BackendConfiguration(baseURL: url)
        return conf
    }
}
