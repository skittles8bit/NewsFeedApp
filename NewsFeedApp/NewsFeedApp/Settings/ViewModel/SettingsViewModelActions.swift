//
//  SettingsViewModelActions.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

struct SettingsViewModelActions {

	enum Events {
		case clearCacheDidTap
		case timerDidChange(TimeIntervalModel)
	}

	let lifecycle = PassthroughSubject<Lifecycle, Never>()
	let events = PassthroughSubject<Events, Never>()
}
