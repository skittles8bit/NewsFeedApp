//
//  SettingsStorageService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import Foundation

protocol SettingsStorageServiceProtocol {
	var isNewsUpdateEnabled: Bool { get }
	var newsUpdateInterval: Int { get }
	var isShowDescriptionEnabled: Bool { get}
	var isNewsSourceEnabled: Bool { get }

	func setValue<T: Sendable>(_ value: T, for key: SettingsStorageService.Keys)
}

final class SettingsStorageService {

	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}
}

// MARK: - SettingsServiceProtocol

extension SettingsStorageService: SettingsStorageServiceProtocol {

	var isNewsUpdateEnabled: Bool {
		userDefaults.bool(forKey: Keys.isNewsUpdateIsEnabled.rawValue)
	}

	var newsUpdateInterval: Int {
		userDefaults.integer(forKey: Keys.newsUpdateInterval.rawValue)
	}

	var isShowDescriptionEnabled: Bool {
		userDefaults.bool(forKey: Keys.isShowDescriptionEnabled.rawValue)
	}

	var isNewsSourceEnabled: Bool {
		userDefaults.bool(forKey: Keys.isNewsSourceEnabled.rawValue)
	}

	func setValue<T: Sendable>(_ value: T, for key: Keys) {
		userDefaults.set(value, forKey: key.rawValue)
	}
}

extension SettingsStorageService {

	enum Keys: String {
		case isNewsUpdateIsEnabled
		case newsUpdateInterval
		case isShowDescriptionEnabled
		case isNewsSourceEnabled
	}
}
