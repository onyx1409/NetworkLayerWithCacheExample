//
//  PublicReposCachedService.swift
//  NetworkLayerForTestTests
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//
@testable import NetworkLayerForTest
import XCTest

class PublicReposCachedServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - Mocks
    class ReposApiWorkingMock: PublicReposStore {
        func createRepos(reposToCreate: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
            
        }
        
        func deleteRepos(reposToDelete: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
            
        }
        
        func fetchRepos(completionHandler: @escaping ([GitRepository], Error?) -> Void) {
            completionHandler([], nil)
        }
    }
    
    class ReposApiNoNetworkMock: PublicReposStore {
        func createRepos(reposToCreate: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
            
        }
        
        func deleteRepos(reposToDelete: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
            
        }
        
        
        func fetchRepos(completionHandler: @escaping ([GitRepository], Error?) -> Void) {
            let error = NSError(domain: "BackendService", code: 0, userInfo: nil)
            completionHandler([], error)
        }
    }
    
    class ReposCacheMock: PublicReposCacheStore {
        
        var reposUpdated = false
        func createRepos(reposToCreate: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
            reposUpdated = true
        }
        
        func deleteRepos(reposToDelete: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
            
        }
        
        
        func fetchRepos(completionHandler: @escaping ([GitRepository], Error?) -> Void) {
            completionHandler([], nil)
        }
        
        var reposWereCleaned = false
        func deleteAllRepos(completionHandler: @escaping (Error?) -> Void) {
            completionHandler(nil)
            reposWereCleaned = true
        }
    }
    
    func testOnlineFetch() {
        let cacheMock = ReposCacheMock()
        let service = PublicReposCachedService(withCacheStore: cacheMock, apiStore: ReposApiWorkingMock())
        
        
        var fetchType: PublicReposCachedService.DataStoreType?
        var fetchError: Error?
        let fetchExpectation = expectation(description: "Wait for service to complete")
        service.fetchRepos { (repos, type, error) in
            fetchType = type
            fetchError = error
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(fetchType, .network, "Source type should be network")
        XCTAssertNil(fetchError, "Error should not be nil")
        XCTAssertTrue(cacheMock.reposUpdated, "repos should be update")
        XCTAssertTrue(cacheMock.reposWereCleaned, "repos should be cleaned")
    }
    
    func testOfflineFetch() {
        let cacheMock = ReposCacheMock()
        let service = PublicReposCachedService(withCacheStore: cacheMock, apiStore: ReposApiNoNetworkMock())
        
        
        var fetchType: PublicReposCachedService.DataStoreType?
        var fetchError: Error?
        let fetchExpectation = expectation(description: "Wait for service to complete")
        service.fetchRepos { (repos, type, error) in
            fetchType = type
            fetchError = error
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(fetchType, .cache, "Source type should be network")
        XCTAssertNil(fetchError, "Error should not be nil")
        XCTAssertFalse(cacheMock.reposUpdated, "Cache should not be updated")
        XCTAssertFalse(cacheMock.reposWereCleaned, "repos should not be cleaned")
    }
}
