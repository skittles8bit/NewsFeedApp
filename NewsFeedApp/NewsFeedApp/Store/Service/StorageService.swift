//
//  StorageService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

protocol StorageServiceProtocol {
	func saveOrUpdate(object: Object)
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

	func saveOrUpdate(object: Object) {
		guard let storage = try? Realm() else { return }
		do {
			try storage.write {
				storage.add(object, update: .modified)
			}
		} catch {
			print(error)
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

extension Results {

	func toArray() -> [Element] {
		.init(self)
	}
}
