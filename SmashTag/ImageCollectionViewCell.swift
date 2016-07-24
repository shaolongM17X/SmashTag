//
//  ImageCollectionViewCell.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	
	var imageURL: NSURL? {
		didSet {
			fetchImageData()
		}
	}
	
	private var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			imageView.image = newValue
		}
	}
	
	private func fetchImageData() {
		if let url = imageURL {
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
				let imageContentData = NSData(contentsOfURL: url)
				dispatch_async(dispatch_get_main_queue()) {
					if url == self.imageURL {
						if let imageData = imageContentData {
							self.image = UIImage(data: imageData)
						}
					}
				}
			}
		}
	}
}
