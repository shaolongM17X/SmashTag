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
	
	private struct FontColors {
		static let HashTagColor = UIColor.redColor()
		static let URLColor = UIColor.blueColor()
		static let UserMentionColor = UIColor.cyanColor()
	}
	
	private var fontColors = [
		"HashTagColor" : UIColor(netHex: 0x0084B4),
		"URLColor" : UIColor(netHex: 0x0084B4),
		"UserMentionColor" : UIColor(netHex: 0x0084B4)
	]
	
	private func setColorAttribute(str: NSMutableAttributedString, tag: String, arr: [Mention]) {
		for item in arr {
			if let color = fontColors[tag] {
				str.addAttributes([NSForegroundColorAttributeName: color], range: item.nsrange)
			}
			
		}
	}
	
	private func getAttributedString(tweet: Twitter.Tweet) -> NSMutableAttributedString {
		let str = NSMutableAttributedString(string: tweet.text)
		// deal with hashtags
		setColorAttribute(str, tag: "HashTagColor", arr: tweet.hashtags)
		setColorAttribute(str, tag: "URLColor", arr: tweet.urls)
		setColorAttribute(str, tag: "UserMentionColor", arr: tweet.userMentions)
		return str
	}
	
	private func updateUI() {
		//reset any existing tweet info
		tweetTextLabel?.attributedText = nil
		tweetScreenNameLabel?.text = nil
		tweetProfileImage?.image = nil
		tweetCreatedLabel?.text = nil
		
		// load new information from tweet
		if let tweet = self.tweet {
			
			// tweet content
			tweetTextLabel?.attributedText = getAttributedString(tweet)
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

// supporting method used to generate color using hex
extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
}
