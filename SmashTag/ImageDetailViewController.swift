//
//  ImageDetailViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
	private var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
		scrollView.addSubview(imageView)
    }

	var image: UIImage? {
		didSet {
			imageView.image = image
			imageView.sizeToFit()
		}
	}
	
	
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
    
	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.contentSize = imageView.frame.size
			scrollView.delegate = self
			scrollView.minimumZoomScale = 0.5
			scrollView.maximumZoomScale = 2.0
			let widthForZoomInRect = min(imageView.frame.width, imageView.frame.height)
			scrollView?.zoomToRect(CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: widthForZoomInRect, height: widthForZoomInRect), animated: false)
		}
	}

	
}
