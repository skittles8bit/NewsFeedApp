//
//  TimeIntervalDataModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

class SettingsDataModel: Object {
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var timeInterval: TimeIntervalDataModel?
}

class TimeIntervalDataModel: Object {
	@objc dynamic var hour: Int = 0
	@objc dynamic var minute: Int = 0
	@objc dynamic var second: Int = 1
}