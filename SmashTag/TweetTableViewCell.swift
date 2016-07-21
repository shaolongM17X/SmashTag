//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/21/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

	var tweet: Twitter.Tweet? {
		didSet {
			updateUI()
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
