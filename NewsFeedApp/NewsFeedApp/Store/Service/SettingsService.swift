//
//  SettingsService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import Foundation

protocol SettingsServiceProtocol {
	var isNewsUpdateEnabled: Bool { get }
	var newsUpdateInterval: Int { get }

	func setNewsUpdate(_ isEnabled: Bool)
	func setNewsUpdateInterval(_ interval: Int)
}

final class SettingsService {

	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}
}

// MARK: - SettingsServiceProtocol

extension SettingsService: SettingsServiceProtocol {

	var isNewsUpdateEnabled: Bool {
		userDefaults.bool(forKey: Keys.newsUpdateEnabled.rawValue)
	}

	var newsUpdateInterval: Int {
		userDefaults.integer(forKey: Keys.newsUpdateInterval.rawValue)
	}

	func setNewsUpdate(_ isEnabled: Bool) {
		userDefaults.set(isEnabled, forKey: Keys.newsUpdateEnabled.rawValue)
	}

	func setNewsUpdateInterval(_ interval: Int) {
		userDefaults.set(interval, forKey: Keys.newsUpdateInterval.rawValue)
	}
}

private extension SettingsService {

	enum Keys: String {
		case newsUpdateEnabled
		case newsUpdateInterval
	}
}
