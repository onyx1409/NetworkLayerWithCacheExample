//
//  PublicReposStore.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation

protocol PublicReposStore {
    func fetchRepos(completionHandler: @escaping ([GitRepository], Error?) -> Void)
    func createRepos(reposToCreate: [GitRepository], completionHandler: @escaping (Error?) -> Void)
    func deleteRepos(reposToDelete: [GitRepository], completionHandler: @escaping (Error?) -> Void)
}
