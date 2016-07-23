//
//  ImageTableViewCell.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBOutlet weak var tweetImage: UIImageView!
	var imageURL: NSURL? {
		didSet {
			fetchImage()
		}
	}
	
	private func fetchImage() {
		if let url = imageURL {
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
				let imageContentData = NSData(contentsOfURL: url)
				dispatch_async(dispatch_get_main_queue()) {
					// make sure the url is still the url we wanted
					if url == self.imageURL {
						if let imageData = imageContentData {
							self.tweetImage.image = UIImage(data: imageData)
						}
					}
				}
				
			}
		}
	}

}
