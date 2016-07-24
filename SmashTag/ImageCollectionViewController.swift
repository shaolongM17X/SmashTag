//
//  ImageCollectionViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import Twitter

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	private struct StoryBoard {
		static let ImageCollectionCellIdentifier = "Image Cell For Collection"
		static let ShowTweetDetailIdentifier = "Show Tweet Detail From Image"
	}
	
	// internal Data Structure
	private struct TweetImage: CustomDebugStringConvertible {
		var tweet: Twitter.Tweet
		var url: NSURL
		var aspectRatio: CGFloat
		
		var debugDescription: String {
			return "\(tweet) with url \(url) and aspectRatio \(aspectRatio)"
		}
	}
	private var tweetImages = [TweetImage]()
	
	private func prepareInternalDataStructure() {
		for tweets in tweetsGroup! {
			for tweet in tweets {
				for media in tweet.media {
					tweetImages.append(TweetImage(tweet: tweet, url: media.url, aspectRatio: CGFloat(media.aspectRatio)))
				}
			}
		}
	}
	
	var tweetsGroup: [Array<Tweet>]? {
		didSet {
			prepareInternalDataStructure()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetImages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoard.ImageCollectionCellIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
		cell.imageURL = tweetImages[indexPath.row].url
        // Configure the cell
    
        return cell
    }
	
	// used to adjust the size of the cell
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let image = tweetImages[indexPath.row]
		return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / image.aspectRatio)
	}
	
	// this is used to prevent the fact that after rotation, the estimated height will be wrong
	override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		collectionView!.reloadData()
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		performSegueWithIdentifier(StoryBoard.ShowTweetDetailIdentifier, sender: tweetImages[indexPath.row].tweet)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryBoard.ShowTweetDetailIdentifier {
			if let destinationVc = segue.destinationViewController as? TweetDetailTableViewController {
				if let tweet = sender as? Tweet {
					destinationVc.tweet = tweet
				}
			}
		}
	}
	

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
