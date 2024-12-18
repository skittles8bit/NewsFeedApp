//
//  TimeIntervalModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

struct TimeIntervalModel {

	var hour: Int { _hour }
	var minute: Int { _minute }
	var second: Int { _second }

	private let _hour: Int
	private let _minute: Int
	private let _second: Int

	init(hour: Int, minute: Int, second: Int) {
		_hour = hour
		_minute = minute
		_second = second
	}
}

extension TimeIntervalModel {

	init(from object: SettingsObject) {
		self.init(
			hour: object.hour,
			minute: object.minute,
			second: object.second
		)
	}
}
