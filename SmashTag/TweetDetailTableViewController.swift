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
	
	private struct StoryBoard {
		static let TweetKeywordCellIdentifier = "Keyword Cell"
		static let TweetImageCellIdentifier = "Image Cell"
		static let KeywordSearchIdentifier = "Search KeyWord"
		static let ShowTweetImageDetailIdentifier = "Show Image"
	}
	
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
		case Image(NSURL, CGFloat, String)
		
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
				mentions.append(Mentions(name: "Image", data: images.map { MentionItem.Image($0.url, CGFloat($0.aspectRatio), $0.description)}))
			}
			prepareMentions("Hashtag", tweetMentions: tweet?.hashtags)
			prepareMentions("Urls", tweetMentions: tweet?.urls)
			prepareMentions("UserMentions", tweetMentions: tweet?.userMentions)
			title = "\(self.tweet!.user)"
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



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let mention = mentions[indexPath.section].data[indexPath.row]
		switch mention {
		case .Image(let url, _, _):
			let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.TweetImageCellIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
			cell.imageURL = url
			return cell
		case .Keyword(let str, _):
			let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.TweetKeywordCellIdentifier, forIndexPath: indexPath)
			cell.textLabel?.text = str
			return cell
		}
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return mentions[section].name
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let mention = mentions[indexPath.section].data[indexPath.row]
		switch mention {
		case .Image(_, let ratio, _):
			return tableView.bounds.width / ratio
		default:
			return UITableViewAutomaticDimension
		}
	}
	
	// this is used to detect user touch, and do segue if necessary
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let mention = mentions[indexPath.section].data[indexPath.row]
		switch mention {
		case .Keyword(let str, _):
			if mentions[indexPath.section].name == "Urls" {
				UIApplication.sharedApplication().openURL(NSURL(string: str)!)
			} else {
				performSegueWithIdentifier(StoryBoard.KeywordSearchIdentifier, sender: str)
			}
		default:
			break
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryBoard.KeywordSearchIdentifier {
			if let keyword = sender as? String {
				if let destinationVc = segue.destinationViewController as? TweetTableViewController {
					destinationVc.searchText = keyword
					SearchHistory().add(keyword)
				}
			}
		}
		if segue.identifier == StoryBoard.ShowTweetImageDetailIdentifier {
			if let imageCell = sender as? ImageTableViewCell {
				if let destinationVc = segue.destinationViewController as? ImageDetailViewController {
					destinationVc.image = imageCell.tweetImage.image!
				}
			}
		}
	}
	
	// this is used to prevent the fact that after rotation, the estimated height will be wrong
	override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		tableView.reloadData()
	}
}
