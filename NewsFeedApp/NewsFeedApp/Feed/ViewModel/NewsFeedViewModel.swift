//
//  NewsFeedViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine
import Foundation

final class NewsFeedViewModel: NewsFeedViewModelActionsAndData {

	/// Зависимости
	struct Dependencies {
		let apiService: APIServiceProtocol
	}

	var newsFeedItems: [NewsModel] = []
	let data: NewsFeedViewModelData

	private(set) lazy var viewActions = NewsFeedViewModelActions()
	private let dependencies: Dependencies
	private let reloadDataSubject = PassthroughSubject<Void, Never>()
	private let loadingSubject = PassthroughSubject<Void, Never>()
	private let errorSubject = PassthroughSubject<Void, Never>()

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости вьюмодели
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		data = NewsFeedViewModelData(
			loadingPublisher: loadingSubject.eraseToAnyPublisher(),
			reloadDataPublisher: reloadDataSubject.eraseToAnyPublisher(),
			errorPublisher: errorSubject.eraseToAnyPublisher()
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
				print("NewsFeed Did Load")
				fetchNewsFeed()
				break
			}
		}.store(in: &subscriptions)

		viewActions.events.sink { [weak self] event in
			guard let self else { return }
			switch event {
			case .refreshDidTap:
				fetchNewsFeed()
			}
		}.store(in: &subscriptions)
	}

	func fetchNewsFeed() {
		loadingSubject.send()
		print("Loading RSS")
		Task {
			do {
				newsFeedItems = try await dependencies.apiService.fetchAndParseRSSFeeds()
				reloadDataSubject.send()
			} catch {
				print("Ошибка при загрузке или разборе RSS: \(error)")
				errorSubject.send()
			}
		}
	}
}
