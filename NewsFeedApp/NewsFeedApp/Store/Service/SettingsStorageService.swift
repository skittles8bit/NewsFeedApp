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

	func setNewsUpdate(_ isEnabled: Bool)
	func setNewsUpdateInterval(_ interval: Int)
	func setShowDescription(_ showDescription: Bool)
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

	func setNewsUpdate(_ isEnabled: Bool) {
		userDefaults.set(isEnabled, forKey: Keys.isNewsUpdateIsEnabled.rawValue)
	}

	func setNewsUpdateInterval(_ interval: Int) {
		userDefaults.set(interval, forKey: Keys.newsUpdateInterval.rawValue)
	}

	func setShowDescription(_ showDescription: Bool) {
		userDefaults.set(showDescription, forKey: Keys.isShowDescriptionEnabled.rawValue)
	}
}

private extension SettingsStorageService {

	enum Keys: String {
		case isNewsUpdateIsEnabled
		case newsUpdateInterval
		case isShowDescriptionEnabled
	}
}
