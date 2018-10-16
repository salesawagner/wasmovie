//
//  PersistenceManager.swift
//  WasMovie
//
//  Created by Wagner Sales on 15/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

class PersistenceManager {

	// MARK: - Properties

	static var realm: Realm? {
		do {
			let realm = try Realm()
			return realm
		} catch _ {
			return nil
		}
	}

	// MARK: - Public Methods

	class func add(_ object: Object) {
		guard let realm = PersistenceManager.realm else {
			return
		}

		self.write {
			realm.add(object, update: true)
		}
	}
	
	class func write(block: Completion) {
		guard let realm = PersistenceManager.realm else {
			return
		}

		if realm.isInWriteTransaction {
			block()
		} else {
			realm.beginWrite()
			block()
			do {
				try realm.commitWrite()
			} catch let error {
				print(error.localizedDescription)
			}
		}
	}
	
	class func objects<T: Object>(objectType: T.Type) -> [T] {
		guard let realm = PersistenceManager.realm else {
			return []
		}
		return Array(realm.objects(objectType))
	}
	
	class func delete(objects: [Object]) {
		guard let realm = self.realm else { return }
		self.write {
			realm.delete(objects)
		}
	}
	
	class func find<T: Object>(text: String) -> T? {
		guard let realm = PersistenceManager.realm else { return nil }
		let predicate = NSPredicate(format: "text = %@", text)
		let result = realm.objects(T.self).filter(predicate)
		return result.first
	}
	
	class func migration() {
		let config = Realm.Configuration(
			schemaVersion: 199,
			migrationBlock: { migration, oldSchemaVersion in

				if (oldSchemaVersion < 1) {}
		})
		
		Realm.Configuration.defaultConfiguration = config
		print(config.fileURL ?? "")
	}
}
