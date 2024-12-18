//
//  SettingsModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

struct SettingsModel {

	var timerModel: TimeIntervalModel { _timerModel }

	private let _timerModel: TimeIntervalModel

	init(timerModel: TimeIntervalModel) {
		_timerModel = timerModel
	}
}
