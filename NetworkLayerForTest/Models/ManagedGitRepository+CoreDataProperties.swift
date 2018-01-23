//
//  ManagedGitRepository+CoreDataProperties.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedGitRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedGitRepository> {
        return NSFetchRequest<ManagedGitRepository>(entityName: "ManagedGitRepository")
    }

    @NSManaged public var id: Int32
    @NSManaged public var fullName: String?
    @NSManaged public var ownerLogin: String?
    @NSManaged public var ownerId: Int32
    @NSManaged public var ownerUrl: String?
    @NSManaged public var descriptionString: String?
    @NSManaged public var url: String?

}
