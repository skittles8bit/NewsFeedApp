//
//  NewsFeedViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine
import Foundation

/// Элиас протоколов вьюмодели ленты новостей
typealias NewsViewModelProtocol =
NewsFeedViewModelActionsAndData & NewsFeedViewModelInputOutput

/// Вью модель ленты новостей
final class NewsFeedViewModel: NewsViewModelProtocol {

	/// Зависимости вьюмодели
	struct Dependencies {
		/// Репозиторий ленты новостей
		let newsRepository: NewsFeedRepositoryProtocol
		/// Репозиторий настроек
		let settingsRepository: SettingsRepositoryProtocol
	}

	/// Входные данные
	let input = NewsFeedViewModelInput()
	/// Выходные данные
	let output: NewsFeedViewModelOutput
	/// Данные вьюмодели
	var data: NewsFeedViewModelData

	private(set) lazy var viewActions = NewsFeedViewModelActions()
	private let dependencies: Dependencies
	private let reloadDataSubject = PassthroughSubject<Void, Never>()
	private let loadingSubject = PassthroughSubject<Void, Never>()
	private let errorSubject = PassthroughSubject<Void, Never>()
	private let performSettingsSubject = PassthroughSubject<Void, Never>()
	private let performArticleDetailSubject = PassthroughSubject<URL, Never>()
	private let applySnapshotSubject = PassthroughSubject<[NewsCellViewModel], Never>()

	private var timer: TimerServiceProtocol?

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
			applySnapshotPublisher: applySnapshotSubject.eraseToAnyPublisher(),
			newsFeedItems: []
		)
		bind()
	}
}

// MARK: - Private

private extension NewsFeedViewModel {

	func bind() {
		viewActions.lifecycle
			.receive(on: DispatchQueue.main)
			.sink { [weak self] lifecycle in
				guard let self else { return }
				switch lifecycle {
				case .didLoad:
					fetchSettings()
					fetchNewsFeed()
				case .willAppear:
					break
				case .didAppear:
					fetchSettings()
					fetchNewsFeed()
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
		applySnapshot()
	}

	func applySnapshot() {
		let models = data.newsFeedItems.compactMap { newsModel in
			NewsCellViewModel(
				item: newsModel,
				isShowDescriptionIsEnabled: data.userSettings?.showDescriptionIsEnabled ?? false
			)
		}
		applySnapshotSubject.send(models)
		reloadDataSubject.send()
	}

	func loadNewsFeed() {
		guard !isLoading else { return }
		loadingSubject.send()
		isLoading = true
		Task {
			guard let news = await dependencies.newsRepository.loadNews() else { return }
			handleNews(with: news)
		}
	}

	func handleNews(with news: [NewsFeedModelDTO]) {
		dependencies.newsRepository.removeAll()
		news.forEach { dependencies.newsRepository.saveObject(with: $0) }
		isLoading = false
		fetchNewsFeed()
	}

	func fetchSettings() {
		data.userSettings = dependencies.settingsRepository.fetchSettings()
		handleSettings(with: data.userSettings)
	}

	func handleSettings(with settings: SettingsModelDTO?) {
		guard let settings else { return }
		if settings.timerIsEnabled {
			let handler: () -> Void = { [weak self] in
				guard let self else { return }
				loadNewsFeed()
			}
			let interval = settings.interval <= 10 ? 10 : settings.interval
			timer = TimerService(
				interval: TimeInterval(interval),
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
