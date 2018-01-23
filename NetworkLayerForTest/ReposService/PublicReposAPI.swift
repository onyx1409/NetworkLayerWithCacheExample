//
//  PublicReposAPI.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

class PublicReposAPI: PublicReposStore {
    
    let backendClient: BackendClient
    
    init() {
        self.backendClient = BackendClient(configuration: BackendConfiguration.gitHubConfiguration())
    }
    
    func fetchRepos(completionHandler: @escaping ([GitRepository], Error?) -> Void) {
        let fetchRequest = PublicReposRequest()
        self.backendClient.request(fetchRequest, success: { (data) in

            DispatchQueue.main.async {
            
                do {
                    guard let data = data else {
                        throw ResponseMapperError.invalid
                    }
                    let repositories = try JSONDecoder().decode([GitRepository].self, from: data)
                    completionHandler (repositories, nil)
                } catch {
                    completionHandler([GitRepository](), error)
                }
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                completionHandler([GitRepository](), error)
            }
        }
    }
    
    func createRepos(reposToCreate: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
    }
    
    func deleteRepos(reposToDelete: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
    }
}
