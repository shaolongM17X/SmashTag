//
//  RecentSearchTableViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {

	private struct StoryBoard {
		static let SearchHistoryEntryIdentifier = "Search History Cell"
		static let FromSearchHistoryToSearchTweetsIdentifier = "From Recent Search To Tweets"
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.estimatedRowHeight = tableView.rowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
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
	}
	
}
