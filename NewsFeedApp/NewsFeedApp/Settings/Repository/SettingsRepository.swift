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
		let settingsObjects = storage.fetch(by: SettingsObject.self)
		guard settingsObjects.count > .zero  else {
			return nil
		}
		guard let object = settingsObjects.last else {
			return nil
		}
		return SettingsModelDTO(from: object)
	}

	func saveSettings(_ settings: SettingsModelDTO) {
		storage.save(objects: [SettingsObject(from: settings)])
	}

	func clearAllCache() {
		storage.deleteAllCache()
	}
}
