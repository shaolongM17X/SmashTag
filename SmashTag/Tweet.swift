//
//  Tweet.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/25/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Tweet: NSManagedObject {

	class func tweetWithTwitterInfo(tweetInfo: Twitter.Tweet, inTheGivenContext context: NSManagedObjectContext, withSearchText searchText: String) -> Tweet? {
		let request = NSFetchRequest(entityName: "Tweet")
		request.predicate = NSPredicate(format: "id = %@", tweetInfo.id)
		// if we can find such entry, we just return the entry. Otherwise, create one
		if let tweetEntry = (try? context.executeFetchRequest(request).first) as? Tweet {
			return tweetEntry
		} else if let tweetEntry = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet {
			tweetEntry.id = tweetInfo.id
			let mentions = mutableSetValueForKey("mentions")
			for hashtagMention in tweetInfo.hashtags {
				if let mentionEntry = Mention.mentionWithSearchText(searchText, withKeyWord: hashtagMention.keyword, inTheGivenContext: context, forSection: "hashtag") {
					mentions.addObject(mentionEntry)
				}
			}
			for userMention in tweetInfo.userMentions {
				if let mentionEntry = Mention.mentionWithSearchText(searchText, withKeyWord: userMention.keyword, inTheGivenContext: context, forSection: "userMention") {
					mentions.addObject(mentionEntry)
				}
			}
			return tweetEntry
		} else {
			return nil
		}
	}

}
