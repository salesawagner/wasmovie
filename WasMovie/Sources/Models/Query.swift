//
//  Query.swift
//  WasMovie
//
//  Created by Wagner Sales on 15/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

class Query: Object {

	// MARK: - Properties

	@objc dynamic var text: String = ""
	@objc dynamic var lastUpdate: Date = Date()

	// MARK: - Constructors
	
	convenience init?(text: String) {
		guard !text.isEmpty else { return nil }
		
		if let result: Query = PersistenceManager.find(text: text) {
			self.init(value: result)
			self.lastUpdate = Date()
		} else {
			self.init()
			self.text = text
		}
	}
	
	// MARK: - Overrides

	override static func primaryKey() -> String? {
		return "text"
	}

	// MARK: - Internal Methods
	
	class func create(text: String) {
		guard let query = Query(text: text) else { return }
		PersistenceManager.add(query)
	}

	class func listAll() -> [Query] {
		let queries: [Query] = PersistenceManager.objects(objectType: self)
		return queries
	}
}
