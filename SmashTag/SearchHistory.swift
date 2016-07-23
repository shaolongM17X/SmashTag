//
//  SearchHistory.swift
//  SmashTag
//
//  Created by Shaolong Lin on 7/23/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import Foundation

class SearchHistory {
	private struct Constants {
		static let SearchHistoryKey = "Search History Key"
		static let MaximumEntryNumber = 100
	}
	
	private let defaults = NSUserDefaults.standardUserDefaults()
	var savedRecords: [String] {
		get {return defaults.objectForKey(Constants.SearchHistoryKey) as? [String] ?? []}
		set {defaults.setObject(newValue, forKey: Constants.SearchHistoryKey)}
	}
	
	func add(str: String?) {
		if str == nil {
			return
		}
		var currentRecords = savedRecords
		// if this record already existed, we will move previous ones
		if let index = currentRecords.indexOf(str!) {
			currentRecords.removeAtIndex(index)
		}
		while currentRecords.count >= Constants.MaximumEntryNumber {
			currentRecords.removeLast()
		}
		currentRecords.insert(str!, atIndex: 0)
		savedRecords = currentRecords
	}

	func removeAtIndex(index: Int) {
		var currentRecords = savedRecords
		currentRecords.removeAtIndex(index)
		savedRecords = currentRecords
	}
}
