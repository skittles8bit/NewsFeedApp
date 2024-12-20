//
//  NewsFeedViewModelData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine

struct NewsFeedViewModelData {

	let loadingPublisher: AnyPublisher<Void, Never>
	let reloadDataPublisher: AnyPublisher<Void, Never>
	let errorPublisher: AnyPublisher<Void, Never>
	let applySnapshotPublisher: AnyPublisher<Void, Never>
	var newsFeedItems: [NewsFeedModelDTO]
}
