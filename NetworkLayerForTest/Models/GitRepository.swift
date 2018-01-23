//
//  GitRepository.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

struct GitRepository: Codable {
    var id: Int
    var fullName: String
    var owner: RepositoryOwner
    var descriptionString: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case descriptionString = "description"
        case url
    }
}

struct RepositoryOwner: Codable {
    var login: String
    var id: Int
    var url: String
    
    enum RepositoryOwnerKeys: String, CodingKey {
        case login
        case id
        case url
    }
    
}
