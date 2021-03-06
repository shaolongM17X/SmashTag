//
//  Tweet+CoreDataProperties.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/25/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var id: String?
    @NSManaged var searchText: String?
    @NSManaged var mentions: NSSet?

}
