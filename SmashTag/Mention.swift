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
		
		let request = NSFetchRequest(entityName: "Mention")
		request.predicate = NSPredicate(format: "searchText = %@ and title = %@", searchText, keyword)
		// see if the mention already existed in the database. If so, increase count. else, create one
		if let mentionEntry = (try? context.executeFetchRequest(request).first) as? Mention {
			mentionEntry.count = Int(mentionEntry.count!) + 1
			return mentionEntry
		} else if let mentionEntry = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
			mentionEntry.count = 1
			mentionEntry.title = keyword
			mentionEntry.searchText = searchText
			mentionEntry.section = section
			return mentionEntry
		} else {
			return nil
		}
	}

}
