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

	func saveSettings(settings: SettingsModelDTO)
	func fetchSettings() -> SettingsModelDTO
}

final class StorageService {

	private let settingsService: SettingsServiceProtocol

	init(settingsService: SettingsServiceProtocol = SettingsService()) {
		self.settingsService = settingsService
	}
}

extension StorageService: StorageServiceProtocol {

	func save(objects: [Object]) {
		do {
			objects.forEach {
				save(object: $0)
			}
		}
	}

	func deleteAllCache() {
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

	func saveSettings(settings: SettingsModelDTO) {
		settingsService.setNewsUpdate(settings.timerEnabled)
		settingsService.setNewsUpdateInterval(settings.period)
	}

	func fetchSettings() -> SettingsModelDTO {
		.init(
			period: settingsService.newsUpdateInterval,
			timerEnabled: settingsService.isNewsUpdateEnabled
		)
	}
}

private extension StorageService {

	func save(object: Object) {
		guard let storage = try? Realm() else { return }
		do {
			try storage.write {
				storage.add(object, update: .all)
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
