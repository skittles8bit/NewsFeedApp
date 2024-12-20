//
//  SettingsRepository.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

protocol SettingsRepositoryProtocol {
	func fetchSettings() -> SettingsModelDTO?
	func saveSettings(_ settings: SettingsModelDTO)
	func clearAllCache()
}

final class SettingsRepository {

	private let storage: StorageServiceProtocol

	init(storage: StorageServiceProtocol) {
		self.storage = storage
	}
}

extension SettingsRepository: SettingsRepositoryProtocol {

	func fetchSettings() -> SettingsModelDTO? {
		storage.fetchSettings()
	}

	func saveSettings(_ settings: SettingsModelDTO) {
		storage.saveSettings(settings: settings)
	}

	func clearAllCache() {
		ImageCache.shared.clearMemoryCache()
		storage.deleteAll()
	}
}
