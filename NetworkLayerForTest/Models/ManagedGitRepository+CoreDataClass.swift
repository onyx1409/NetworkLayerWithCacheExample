//
//  ManagedGitRepository+CoreDataClass.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedGitRepository)
public class ManagedGitRepository: NSManagedObject {

    func toGitRepository() -> GitRepository {
        let owner = RepositoryOwner(login: ownerLogin ?? "", id: Int(ownerId), url: ownerUrl ?? "")
        
        return GitRepository(id: Int(id), fullName: fullName ?? "", owner: owner, descriptionString: descriptionString ?? "", url: url ?? "")
    }
    
    func fromGitRepository(repository: GitRepository) {
        
        id = Int32(repository.id)
        fullName = repository.fullName
        descriptionString = repository.descriptionString
        url = repository.url
        
        ownerId = Int32(repository.owner.id)
        ownerLogin = repository.owner.login
        ownerUrl = repository.owner.url
    }
}
