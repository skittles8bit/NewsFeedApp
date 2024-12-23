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
	/// Удалить все записи по типу
	func deleteAll<T: Object>(by type: T.Type)
	/// Удалить определенный объект по типу
	func delete<T: Object>(
		by type: T.Type,
		and id: String
	)
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

	func deleteAll<T: Object>(by type: T.Type) {
		guard let storage = try? Realm() else { return }
		let objects = storage.objects(T.self)
		do {
			try storage.write {
				storage.delete(objects)
			}
		} catch {
			print(error)
		}
	}

	func delete<T: Object>(by type: T.Type, and id: String) {
		guard
			let storage = try? Realm(),
			let object = storage.object(ofType: type, forPrimaryKey: id)
		else {
			return
		}
		do {
			try storage.write {
				storage.delete(object)
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
		settingsStorageService.setValue(settings.timerIsEnabled, for: .isNewsUpdateIsEnabled)
		settingsStorageService.setValue(settings.interval, for: .newsUpdateInterval)
		settingsStorageService.setValue(settings.showDescriptionIsEnabled, for: .isShowDescriptionEnabled)
		settingsStorageService.setValue(settings.newsSourceIsEnabled, for: .isNewsSourceEnabled)
	}

	func fetchSettings() -> SettingsModelDTO {
		.init(
			interval: settingsStorageService.newsUpdateInterval,
			timerIsEnabled: settingsStorageService.isNewsUpdateEnabled,
			showDescriptionIsEnabled: settingsStorageService.isShowDescriptionEnabled,
			newsSourceIsEnabled: settingsStorageService.isNewsSourceEnabled
		)
	}
}

extension Results {

	func toArray() -> [Element] {
		.init(self)
	}
}
