//
//  NewsFeedViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine
import Foundation

typealias NewsViewModelProtocol =
NewsFeedViewModelActionsAndData & NewsFeedViewModelInputOutput

final class NewsFeedViewModel: NewsViewModelProtocol {

	/// Зависимости
	struct Dependencies {
		let repository: NewsFeedRepository
	}

	let input = NewsFeedViewModelInput()
	let output: NewsFeedViewModelOutput
	var data: NewsFeedViewModelData

	private(set) lazy var viewActions = NewsFeedViewModelActions()
	private let dependencies: Dependencies
	private let reloadDataSubject = PassthroughSubject<Void, Never>()
	private let loadingSubject = PassthroughSubject<Void, Never>()
	private let errorSubject = PassthroughSubject<Void, Never>()
	private let performSettingsSubject = PassthroughSubject<Void, Never>()

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости вьюмодели
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		output = NewsFeedViewModelOutput(
			performSettingsPublisher: performSettingsSubject.eraseToAnyPublisher()
		)
		data = NewsFeedViewModelData(
			loadingPublisher: loadingSubject.eraseToAnyPublisher(),
			reloadDataPublisher: reloadDataSubject.eraseToAnyPublisher(),
			errorPublisher: errorSubject.eraseToAnyPublisher(),
			newsFeedItems: []
		)
		bind()
	}
}

private extension NewsFeedViewModel {

	func bind() {
		viewActions.lifecycle
			.receive(on: DispatchQueue.main)
			.sink { [weak self] lifecycle in
				guard let self else { return }
				switch lifecycle {
				case .didLoad:
					fetchNewsFeed()
				}
			}.store(in: &subscriptions)

		viewActions.events
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				guard let self else { return }
				switch event {
				case .refreshDidTap:
					fetchNewsFeed()
				case .settingsDidTap:
					performSettingsSubject.send()
				}
			}.store(in: &subscriptions)
	}

	func fetchNewsFeed() {
		loadingSubject.send()
		Task {
			guard let news = await self.dependencies.repository.fetchNewsFeed() else {
				self.errorSubject.send()
				return
			}
			self.data.newsFeedItems = news
			self.reloadDataSubject.send()
		}
	}
}
