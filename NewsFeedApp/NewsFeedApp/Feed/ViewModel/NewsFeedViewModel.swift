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
					fetchUserSettings()
					loadNewsFeed()
				case .willAppear:
					break
				case .didAppear:
					fetchUserSettings()
					loadNewsFeed()
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

	func fetchNewsFeed() -> [NewsFeedModelDTO] {
		dependencies.newsRepository.fetchNewsFeed()?.sortNews() ?? []
	}

	func applySnapshot() {
		let news = data.newsFeedItems.sortNews()
		let models = news.compactMap { newsModel in
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
			guard
				let news = await dependencies.newsRepository.loadNews(
					isSourceEnabled: data.userSettings?.newsSourceIsEnabled ?? false
				)
			else {
				handleError()
				return
			}
			handleNews(with: news)
			applySnapshot()
		}
	}

	func handleError() {
		isLoading = false
		errorSubject.send()
	}

	func handleNews(with news: [NewsFeedModelDTO]) {
		isLoading = false
		data.newsFeedItems = fetchNewsFeed()
		let newObjects = news.filter { model in
			data.newsFeedItems.first { model.title == $0.title }?.title != model.title
		}
		guard !newObjects.isEmpty else {
			applySnapshot()
			return
		}
		newObjects.forEach { dependencies.newsRepository.saveObject(with: $0) }
		newObjects.forEach { data.newsFeedItems.append($0) }
		applySnapshot()
	}

	func fetchUserSettings() {
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
		var model = data.newsFeedItems[index]
		model.isArticleReaded = true
		dependencies.newsRepository.saveObject(with: model)
		performArticleDetailSubject.send(url)
	}
}
