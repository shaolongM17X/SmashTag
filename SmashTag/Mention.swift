//
//  Mention.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/25/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import Foundation
import CoreData


class Mention: NSManagedObject {

	class func mentionWithSearchText(searchText: String, withKeyWord keyword: String, inTheGivenContext context: NSManagedObjectContext, forSection section: String) -> Mention? {
		// see if the mention already existed in the database. If so, increase count. else, create one
		
		return nil
	}

}
