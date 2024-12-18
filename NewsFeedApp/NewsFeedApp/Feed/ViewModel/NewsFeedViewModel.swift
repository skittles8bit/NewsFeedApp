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
		let apiService: APIServiceProtocol
		let coreDataService: CoreDataServiceProtocol
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
		viewActions.lifecycle.sink { [weak self] lifecycle in
			guard let self else { return }
			switch lifecycle {
			case .didLoad:
				fetchNewsFeed()
			}
		}.store(in: &subscriptions)

		viewActions.events.sink { [weak self] event in
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
		if let models = dependencies.coreDataService.fetchNews() {
			data.newsFeedItems = models
		}
		loadingSubject.send()
		Task {
			do {
				data.newsFeedItems = try await dependencies.apiService.fetchAndParseRSSFeeds()
				data.newsFeedItems.forEach { model in
					dependencies.coreDataService.saveNews(with: model)
				}
				reloadDataSubject.send()
			} catch {
				print("Ошибка при загрузке или разборе RSS: \(error)")
				errorSubject.send()
			}
		}
	}
}
