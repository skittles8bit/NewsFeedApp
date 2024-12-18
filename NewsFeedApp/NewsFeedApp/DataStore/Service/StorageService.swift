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
	func saveSettings(with model: SettingsModel)
	func getSettings() -> SettingsModel?
	func fetch<T: Object>(by type: T.Type) -> [T]
}

final class StorageService {

	private lazy var configuration: Realm.Configuration = {
		Realm.Configuration(inMemoryIdentifier: "inMemory")
	}()
}

extension StorageService: StorageServiceProtocol {

	func save(object: Object) {
		guard let storage = try? Realm(configuration: configuration) else { return }
		do {
			try? storage.write {
				storage.add(object)
			}
		}
	}

	func save(objects: [Object]) {
		do {
			objects.forEach {
				save(object: $0)
			}
		}
	}

	// Добавление новости
	func saveNews(with model: NewsFeedModelDTO) {
		guard let storage = try? Realm(configuration: configuration) else { return }
		let news = NewsFeedObject()
		news.title = model.title
		news.subtitle = model.description
		news.publicationDate = model.publicationDate
		news.link = model.link
		news.imageURL = model.imageURL
		news.channel = model.channel
		try? storage.write {
			storage.add(news)
		}
	}

	func deleteAllCache() {
		ImageLoader.shared.clearCache()
		guard let storage = try? Realm(configuration: configuration) else { return }
		do {
			try storage.write {
				storage.deleteAll()
			}
		} catch {
			print(error)
		}
	}

	func saveSettings(with model: SettingsModel) {
//		do {
//			let realm = try Realm()
//			let settings = SettingsDataModel()
//			settings.hour = model.timerModel.hour
//			settings.minute = model.timerModel.minute
//			settings.second = model.timerModel.second
//			settings.timerEnabled = model.timerEnabled
//			do {
//				try realm.write {
//					realm.add(settings)
//				}
//			}
//		} catch {
//			print(error)
//		}
	}

	func getSettings() -> SettingsModel? {
//		do {
//			let realm = try Realm()
//			let settings = realm.objects(SettingsDataModel.self).first
//			guard let settings else { return nil }
//			return SettingsModel(
//				timerModel: .init(
//					hour: settings.hour,
//					minute: settings.minute,
//					second: settings.second
//				),
//				timerEnabled: settings.timerEnabled
//			)
//		} catch {
//			print(error)
//			return nil
//		}
		return nil
	}

	func fetch<T: Object>(by type: T.Type) -> [T] {
		guard let storage = try? Realm(configuration: configuration) else { return [] }
		return storage.objects(T.self).toArray()
	}
}

extension Results {

	func toArray() -> [Element] {
		.init(self)
	}
}
