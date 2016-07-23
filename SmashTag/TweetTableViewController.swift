//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/21/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
	
	private struct StoryBoard {
		static let TweetCellIdentifier = "Tweet"
		static let TweetDetailSegueIdentifier = "Tweet Detail Segue"
	}
	
	var tweets = [Array<Tweet>]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	var searchText: String? {
		didSet {
			tweets.removeAll()
			searchForTweets()
			title = searchText
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
						}
					}
				}
			}
		}
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
		searchText = textField.text
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
