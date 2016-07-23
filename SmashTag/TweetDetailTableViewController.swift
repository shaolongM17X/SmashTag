//
//  TweetDetailTableViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/22/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
	
	// internal data structure
	private var mentions = [Mentions]()
	
	private struct Mentions: CustomDebugStringConvertible {
		var name: String
		var data: [MentionItem]
		
		var debugDescription: String {
			return "\(name): data: \(data)"
		}
	}
	
	private enum MentionItem: CustomDebugStringConvertible {
		case Keyword(String, String)
		case Image(NSURL, Double, String)
		
		var debugDescription: String {
			switch self {
			case .Keyword(_, let str):
				return str
			case .Image(_, _, let str):
				return str
			}
		}
	}
	
	// when the tweet is set, we are gonna update our internal data structure
	var tweet: Twitter.Tweet? {
		didSet {
			if let images = tweet?.media where images.count > 0 {
				mentions.append(Mentions(name: "Image", data: images.map { MentionItem.Image($0.url, $0.aspectRatio, $0.description)}))
			}
			prepareMentions("Hashtag", tweetMentions: tweet?.hashtags)
			prepareMentions("Urls", tweetMentions: tweet?.urls)
			prepareMentions("UserMentions", tweetMentions: tweet?.userMentions)
			print(mentions)
		}
	}
	
	private func prepareMentions(name: String, tweetMentions: [Mention]?) {
		if let arr = tweetMentions where arr.count > 0 {
			mentions.append(Mentions(name: name, data: arr.map{MentionItem.Keyword($0.keyword, $0.description)}))
		}
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
