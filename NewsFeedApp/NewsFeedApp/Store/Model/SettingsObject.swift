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
	@Persisted var period: Int = 10
}

extension SettingsObject {

	convenience init(from settings: SettingsModelDTO) {
		self.init()
		timerEnabled = settings.timerEnabled
		period = settings.period
	}
}
