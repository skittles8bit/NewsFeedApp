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
		let newsRepository: NewsFeedRepository
		let settingsRepository: SettingsRepository
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

	private var timer: NewsTimerProtocol?

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
				case .willAppear:
					fetchSettings()
				case .willDisappear:
					timer?.stop()
				}
			}.store(in: &subscriptions)

		viewActions.events
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				guard let self else { return }
				switch event {
				case .didUpdate:
					loadNewsFeed()
				case .didTapSettings:
					performSettingsSubject.send()
				}
			}.store(in: &subscriptions)
	}

	func fetchNewsFeed() {
		loadingSubject.send()
		Task {
			guard let news = await self.dependencies.newsRepository.fetchNewsFeed() else {
				errorSubject.send()
				return
			}
			data.newsFeedItems = news
			reloadDataSubject.send()
		}
	}

	func loadNewsFeed() {
		loadingSubject.send()
		Task {
			guard let news = await self.dependencies.newsRepository.loadNews() else {
				errorSubject.send()
				return
			}
			data.newsFeedItems = news
			reloadDataSubject.send()
		}
	}

	func fetchSettings() {
		let settings = dependencies.settingsRepository.fetchSettings()
		guard let settings else { return }
		if settings.timerEnabled {
			let handler: () -> Void = { [weak self] in
				guard let self else { return }
				loadNewsFeed()
			}
			timer = NewsTimer(
				interval: TimeInterval(settings.period),
				updateHandler: handler
			)
		} else {
			timer?.stop()
		}
	}
}
