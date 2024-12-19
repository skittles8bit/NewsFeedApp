//
//  StorageService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

protocol StorageServiceProtocol {
	func save(objects: [Object])
	func deleteAllCache()
	func fetch<T: Object>(by type: T.Type) -> [T]
}

final class StorageService {}

extension StorageService: StorageServiceProtocol {

	func save(objects: [Object]) {
		do {
			objects.forEach {
				save(object: $0)
			}
		}
	}

	func deleteAllCache() {
		ImageLoader.shared.clearCache()
		guard let storage = try? Realm() else { return }
		do {
			try storage.write {
				storage.deleteAll()
			}
		} catch {
			print(error)
		}
	}

	func fetch<T: Object>(by type: T.Type) -> [T] {
		guard let storage = try? Realm() else { return [] }
		return storage.objects(T.self).toArray()
	}
}

private extension StorageService {

	func save(object: Object) {
		guard let storage = try? Realm() else { return }
		do {
			try storage.write {
				storage.add(object)
			}
		} catch {
			print(error)
		}
	}
}

extension Results {

	func toArray() -> [Element] {
		.init(self)
	}
}
