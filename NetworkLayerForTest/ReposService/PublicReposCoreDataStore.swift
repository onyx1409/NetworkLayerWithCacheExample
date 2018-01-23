//
//  PublicReposCoreDataStore.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import Foundation
import CoreData

protocol PublicReposCacheStore: PublicReposStore {
    func deleteAllRepos(completionHandler: @escaping (Error?) -> Void)
}

class PublicReposCoreDataStore: PublicReposCacheStore {
    
    deinit
    {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NetworkLayerForTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Notifications
    
    func fetchRepos(completionHandler: @escaping ([GitRepository], Error?) -> Void) {
        let context = persistentContainer.viewContext
        let reposRequest: NSFetchRequest<ManagedGitRepository> = ManagedGitRepository.fetchRequest()
        do {
            let results = try context.fetch(reposRequest)
            let repos = results.map { $0.toGitRepository() }
            completionHandler(repos, nil)
        } catch {
            completionHandler([], error)
        }
    }
    
    func createRepos(reposToCreate: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                for repo in reposToCreate {
                    let managedRepo = ManagedGitRepository(context: context)
                    managedRepo.fromGitRepository(repository: repo)
                }
                try context.save()
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }
    
    func deleteRepos(reposToDelete: [GitRepository], completionHandler: @escaping (Error?) -> Void) {
        //Do nothing for now, use deleteAllRepos instead
    }
    
    func deleteAllRepos(completionHandler: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                let allReposRequest: NSFetchRequest<ManagedGitRepository> = ManagedGitRepository.fetchRequest()
                let results = try context.fetch(allReposRequest)
                for managedRepo in results {
                    context.delete(managedRepo)
                }
                try context.save()
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }
        
}
