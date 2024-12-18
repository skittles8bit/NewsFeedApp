//
//  SettingsObject.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

class SettingsObject: Object {

	@Persisted(primaryKey: true) var id: String = UUID().uuidString // Уникальный идентификатор
	@Persisted var timerEnabled: Bool = false
	@Persisted var hour: Int = 0
	@Persisted var minute: Int = 0
	@Persisted var second: Int = 1
}

extension SettingsObject {

	convenience init(from settings: SettingsModelDTO) {
		self.init()
		timerEnabled = settings.timerEnabled
		hour = settings.timerModel.hour
		minute = settings.timerModel.minute
		second = settings.timerModel.second
	}
}
