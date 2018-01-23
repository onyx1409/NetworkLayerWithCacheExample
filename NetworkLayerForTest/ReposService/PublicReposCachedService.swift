//
//  PublicReposCachedService.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

class PublicReposCachedService {
    
    let cacheStore: PublicReposCacheStore
    let apiStore: PublicReposStore
    
    init(withCacheStore cacheStore: PublicReposCacheStore, apiStore: PublicReposStore) {
        self.cacheStore = cacheStore
        self.apiStore = apiStore
    }
    
    enum DataStoreType: String {
        case cache = "From device cache"
        case network = "From network"
    }
    
    func fetchRepos(completionHandler: @escaping ([GitRepository], DataStoreType, Error?) -> Void) {
        apiStore.fetchRepos { (repos, error) in
            if let _ = error {
                self.cacheStore.fetchRepos(completionHandler: { (reposFromCache, error) in
                    if let error = error {
                        completionHandler([], .cache, error)
                        return
                    }
                    completionHandler(reposFromCache, .cache, nil)
                })
                return
            }
            
            completionHandler(repos, .network, nil)
            
            self.cacheStore.deleteAllRepos(completionHandler: { (error) in
                if let error = error {
                    print(error)
                    return
                }
                
                self.cacheStore.createRepos(reposToCreate: repos, completionHandler: { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                })
            })
            
        }
    }
    
}
