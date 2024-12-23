//
//  SettingsRepository.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

/// Протокол репозитория настроек
protocol SettingsRepositoryProtocol {
	/// Получение настроек
	///  - returns: Настройки
	func fetchSettings() -> SettingsModelDTO?
	/// Сохранения настроек
	///  - Parameters:
	///   - settings: Модель данных настроек
	func saveSettings(_ settings: SettingsModelDTO)
	/// Очистить весь кэш приложения
	func clearAllCache()
}

/// Репозиторий настроек
final class SettingsRepository {

	private let storage: StorageServiceProtocol

	/// Инициализатор
	///  - Parameters:
	///   - storage: Сервис хранения данных
	init(storage: StorageServiceProtocol) {
		self.storage = storage
	}
}

// MARK: - SettingsRepositoryProtocol

extension SettingsRepository: SettingsRepositoryProtocol {

	func fetchSettings() -> SettingsModelDTO? {
		storage.fetchSettings()
	}

	func saveSettings(_ settings: SettingsModelDTO) {
		storage.saveSettings(settings: settings)
	}

	func clearAllCache() {
		ImageCache.shared.clearMemoryCache()
		storage.deleteAll(by: NewsFeedObject.self)
	}
}
