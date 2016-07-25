//
//  RecentSearchTableViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchTableViewController: UITableViewController {

	private struct StoryBoard {
		static let SearchHistoryEntryIdentifier = "Search History Cell"
		static let FromSearchHistoryToSearchTweetsIdentifier = "From Recent Search To Tweets"
		static let ShowMentionDetailsIdentifier = "Show Mention Details"
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.estimatedRowHeight = tableView.rowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
		
		// add edit button
		navigationItem.leftBarButtonItem = editButtonItem()
    }
	
	// used to delete a selected row
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		SearchHistory().removeAtIndex(indexPath.row)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		
		// remove this entry from database
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		let searchText = (cell?.textLabel?.text)!
		let request = NSFetchRequest(entityName: "Tweet")
		request.predicate = NSPredicate(format: "searchText = %@", searchText)
		let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
		managedObjectContext?.performBlockAndWait {
			
			if let tweets = (try? managedObjectContext?.executeFetchRequest(request)) as? [Tweet] {
				for tweet in tweets {
					managedObjectContext?.deleteObject(tweet)
				}
			}
			do {
				try managedObjectContext?.save()
			} catch let error {
				print("Something is wrong during deletion. Error \(error)")
			}
		}
		
	}
	
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SearchHistory().savedRecords.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.SearchHistoryEntryIdentifier, forIndexPath: indexPath)
		cell.textLabel?.text = SearchHistory().savedRecords[indexPath.row]
		return cell
	}
	
	// when user select a row, we will do the search again
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		performSegueWithIdentifier(StoryBoard.FromSearchHistoryToSearchTweetsIdentifier, sender: SearchHistory().savedRecords[indexPath.row])
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryBoard.FromSearchHistoryToSearchTweetsIdentifier {
			if let searchText = sender as? String {
				if let destinationVc = segue.destinationViewController as? TweetTableViewController {
					destinationVc.searchText = searchText
				}
			}
		}
		
		if segue.identifier == StoryBoard.ShowMentionDetailsIdentifier {
			if let destinationVc = segue.destinationViewController as? MentionsTableViewController {
				if let histMentionCell = sender as? UITableViewCell {
					destinationVc.searchText = histMentionCell.textLabel?.text
					destinationVc.managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
				}
			}
		}
	}
	
}
