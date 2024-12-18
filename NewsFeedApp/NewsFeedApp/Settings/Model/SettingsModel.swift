//
//  SettingsModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

struct SettingsModel {

	var timerModel: TimeIntervalModel { _timerModel }
	var timerEnabled: Bool { _timerEnabled }

	private let _timerModel: TimeIntervalModel
	private let _timerEnabled: Bool

	init(timerModel: TimeIntervalModel, timerEnabled: Bool) {
		_timerModel = timerModel
		_timerEnabled = timerEnabled
	}
}
