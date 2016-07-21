//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/21/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

	
	@IBOutlet weak var tweetProfileImage: UIImageView!
	@IBOutlet weak var tweetCreatedLabel: UILabel!
	@IBOutlet weak var tweetScreenNameLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	
	var tweet: Twitter.Tweet? {
		didSet {
			updateUI()
		}
	}
	
	private func updateUI() {
		//reset any existing tweet info
		tweetTextLabel?.attributedText = nil
		tweetScreenNameLabel?.text = nil
		tweetProfileImage?.image = nil
		tweetCreatedLabel?.text = nil
		
		// load new information from tweet
		if let tweet = self.tweet {
			tweetTextLabel?.text = tweet.text
			if tweetTextLabel?.text != nil {
				for _ in tweet.media {
					tweetTextLabel.text! += " 📸"
				}
			}
			
			tweetScreenNameLabel?.text = "\(tweet.user)"
			
			if let profileImageURL = tweet.user.profileImageURL {
				if let imageData = NSData(contentsOfURL: profileImageURL) { // TODO
					tweetProfileImage?.image = UIImage(data: imageData)
				}
			}
			
			let formatter = NSDateFormatter()
			if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
				formatter.dateStyle = NSDateFormatterStyle.ShortStyle
			} else {
				formatter.timeStyle = NSDateFormatterStyle.ShortStyle
			}
			tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
		}
	}
//	
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
