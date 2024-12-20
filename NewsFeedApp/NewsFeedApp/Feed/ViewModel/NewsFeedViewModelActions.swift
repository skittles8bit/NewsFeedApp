//
//  NewsFeedViewModelActions.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine

struct NewsFeedViewModelActions {

	enum Events {
		case didUpdate
		case didTapSettings
		case didTapArticle(Int)
		case didTapMoreButton(Int)
	}

	let lifecycle = PassthroughSubject<Lifecycle, Never>()
	let events = PassthroughSubject<Events, Never>()
}
