//
//  SettingsModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

struct SettingsModelDTO {

	var timerEnabled: Bool { _timerEnabled }
	var period: Int { _period }

	private let _period: Int
	private let _timerEnabled: Bool

	init(period: Int, timerEnabled: Bool) {
		_period = period
		_timerEnabled = timerEnabled
	}
}
