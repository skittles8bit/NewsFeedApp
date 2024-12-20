//
//  StorageService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

/// Протокол сервиса работы с БД
protocol StorageServiceProtocol {
	/// Сохранить или обновить объект
	///  - Parameters:
	///   - object: Объект
	func saveOrUpdate(object: Object)
	/// Удалить все записи
	func deleteAll()
	/// Получение объекта
	///  - Parameters:
	///   - type: Тип объекта
	///  - returns: Объект из БД
	func fetch<T: Object>(by type: T.Type) -> [T]
	/// Сохранение настроек приложения
	///  - Parameters:
	///   - settings: Модель данных настроек
	func saveSettings(settings: SettingsModelDTO)
	/// Получение настроек
	///  - returns: Модель данных настроек
	func fetchSettings() -> SettingsModelDTO
}

/// Сервис работы с БД
final class StorageService {

	private let settingsStorageService: SettingsStorageServiceProtocol

	/// Инициализатор
	///  - Parameters:
	///   - settingsStorageService: Сервис сохранения настроек
	init(settingsStorageService: SettingsStorageServiceProtocol = SettingsStorageService()) {
		self.settingsStorageService = settingsStorageService
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

	func deleteAll() {
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
		settingsStorageService.setNewsUpdate(settings.timerIsEnabled)
		settingsStorageService.setNewsUpdateInterval(settings.interval)
		settingsStorageService.setShowDescription(settings.showDescriptionIsEnabled)
	}

	func fetchSettings() -> SettingsModelDTO {
		.init(
			interval: settingsStorageService.newsUpdateInterval,
			timerIsEnabled: settingsStorageService.isNewsUpdateEnabled,
			showDescriptionIsEnabled: settingsStorageService.isShowDescriptionEnabled
		)
	}
}

extension Results {

	func toArray() -> [Element] {
		.init(self)
	}
}
