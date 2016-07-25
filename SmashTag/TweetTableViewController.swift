//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/21/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
	
	var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
	
	private struct StoryBoard {
		static let TweetCellIdentifier = "Tweet"
		static let TweetDetailSegueIdentifier = "Tweet Detail Segue"
		static let SearchImagesWithCurrentSearchTextIdentifier = "Search Images"
	}
	
	var tweets = [Array<Twitter.Tweet>]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	var searchText: String? {
		didSet {
			tweets.removeAll()
			searchForTweets()
			title = searchText
			SearchHistory().add(searchText)
		}
	}
	
	private var twitterRequest: Twitter.Request? {
		if let query = searchText where !query.isEmpty {
			return Twitter.Request(search: query + "-filter:retweets", count: 100)
		}
		return nil
	}
	// used to keep track of last request, and compare it with current request to decide whether or not to update
	private var lastTwitterRequest: Twitter.Request?
	private func searchForTweets() {
		if let request = twitterRequest {
			lastTwitterRequest = request
			request.fetchTweets { [weak weakSelf = self] newTweets in
				dispatch_async(dispatch_get_main_queue()) {
					if request == weakSelf?.lastTwitterRequest {
						if !newTweets.isEmpty {
							weakSelf?.tweets.insert(newTweets, atIndex: 0)
							weakSelf?.updateDatabase(newTweets)
						}
					}
				}
			}
		}
	}
	
	private func updateDatabase(newTweets: [Twitter.Tweet]) {
		managedObjectContext?.performBlock {
			for tweet in newTweets {
				_ = Tweet.tweetWithTwitterInfo(tweet, inTheGivenContext: self.managedObjectContext!, withSearchText: self.searchText!)
			}
			do {
				try self.managedObjectContext?.save()
			} catch let error {
				print("Error occured in saving. \(error)")
			}
		}
		printDatabaseStatistics()
	}
	
	private func printDatabaseStatistics() {
		let tweetCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
		let mentionsCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Mention"), error: nil)
		print("There are \(tweetCount) tweets and \(mentionsCount) mentions saved in database")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// adjust the height automatically
		tableView.estimatedRowHeight = tableView.rowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
	}

	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

	
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tweets[section].count
    }
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.TweetCellIdentifier, forIndexPath: indexPath)
		let tweet = tweets[indexPath.section][indexPath.row]
		if let tweetCell = cell as? TweetTableViewCell {
			tweetCell.tweet = tweet
		}

        // Configure the cell...

        return cell
    }
	@IBOutlet weak var searchTextField: UITextField! {
		didSet {
			searchTextField.delegate = self
			searchTextField.text = searchText
		}
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField.text?.characters.count > 0 {
			searchText = textField.text
		}
		return true
	}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

       // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryBoard.TweetDetailSegueIdentifier {
			if let tweetCell = sender as? TweetTableViewCell {
				if let destinationVc = segue.destinationViewController.contentViewController as? TweetDetailTableViewController {
					destinationVc.tweet = tweetCell.tweet
				}
			}
		}
		if segue.identifier == StoryBoard.SearchImagesWithCurrentSearchTextIdentifier {
			if let destinationVc = segue.destinationViewController as? ImageCollectionViewController {
				destinationVc.tweetsGroup = tweets
			}
		}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		if identifier == StoryBoard.SearchImagesWithCurrentSearchTextIdentifier && searchText == nil {
			return false
		}
		return true
	}
 

}

extension UIViewController {
	var contentViewController: UIViewController {
		if let navcon = self as? UINavigationController {
			return navcon.visibleViewController ?? self
		} else {
			return self
		}
	}
}
