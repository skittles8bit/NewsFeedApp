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
		let newsRepository: NewsFeedRepositoryProtocol
		let settingsRepository: SettingsRepositoryProtocol
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
	private let performArticleDetailSubject = PassthroughSubject<URL, Never>()

	private var timer: NewsTimerProtocol?

	private var isLoading: Bool = false

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости вьюмодели
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		output = NewsFeedViewModelOutput(
			performSettingsPublisher: performSettingsSubject.eraseToAnyPublisher(),
			performArticleDetailPublisher: performArticleDetailSubject.eraseToAnyPublisher()
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
					fetchNewsFeed()
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
				case let .didTapArticle(index):
					performArticleDetails(with: index)
				}
			}.store(in: &subscriptions)
	}

	func fetchNewsFeed() {
		guard !isLoading else { return }
		let objects = dependencies.newsRepository.fetchNewsFeed()
		guard let objects, objects.count > .zero else {
			loadNewsFeed()
			return
		}
		data.newsFeedItems = objects
		reloadDataSubject.send()
	}

	func loadNewsFeed() {
		guard !isLoading else { return }
		loadingSubject.send()
		isLoading = true
		Task {
			guard let news = await dependencies.newsRepository.loadNews() else { return }
			dependencies.newsRepository.removeAll()
			news.forEach { dependencies.newsRepository.saveObject(with: $0) }
			isLoading = false
			fetchNewsFeed()
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
			let period = settings.period <= 10 ? 10 : settings.period
			timer = NewsTimer(
				interval: TimeInterval(period),
				updateHandler: handler
			)
		} else {
			timer?.stop()
		}
	}

	func performArticleDetails(with index: Int) {
		guard
			let link = data.newsFeedItems[index].link,
			let url = URL(string: link)
		else {
			return
		}
		data.newsFeedItems[index].isArticleReaded = true
		dependencies.newsRepository.saveObject(with: data.newsFeedItems[index])
		performArticleDetailSubject.send(url)
	}
}
