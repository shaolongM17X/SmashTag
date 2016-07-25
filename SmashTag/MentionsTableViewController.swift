//
//  MentionsTableViewController.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/25/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit
import CoreData

class MentionsTableViewController: CoreDataTableViewController {

	var searchText: String? {didSet {updateUI()}}
	var managedObjectContext: NSManagedObjectContext? {didSet {updateUI()}}
	
	private func updateUI() {
		if let context = managedObjectContext where searchText?.characters.count > 0 {
			let request = NSFetchRequest(entityName: "Mention")
			request.predicate = NSPredicate(format: "searchText = %@ and count > 1", searchText!)
			request.sortDescriptors = [
				NSSortDescriptor(
					key: "section",
					ascending: true,
					selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
				),
				NSSortDescriptor(
					key: "count",
					ascending: false
				),
				NSSortDescriptor(
					key: "title",
					ascending: true,
					selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
				)
			]
			fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
			                                                      managedObjectContext: context,
			                                                      sectionNameKeyPath: "section",
			                                                      cacheName: nil)
		} else {
			fetchedResultsController = nil
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.MentionTableCellIdentifier, forIndexPath: indexPath)
		if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention {
			var title: String?
			var count: Int?
			mention.managedObjectContext?.performBlockAndWait {
				title = mention.title
				count = Int(mention.count!)
			}
			cell.textLabel?.text = title
			cell.detailTextLabel?.text = String(count!)
			
		}
		return cell
	}
	
	
	private struct StoryBoard {
		static let MentionTableCellIdentifier = "Mention Cell"
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
	}


}
