//
//  NewsFeedViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine

final class NewsFeedViewModel: NewsFeedViewModelActionsProtocol {

	/// Зависимости
	struct Dependencies {
		let apiService: APIServiceProtocol
	}

	private(set) lazy var viewActions = NewsFeedViewModelActions()
	private let dependencies: Dependencies
	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости вьюмодели
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
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
	}

	func fetchNewsFeed() {
		print("Loading RSS")
		Task {
			do {
				let items = try await dependencies.apiService.fetchAndParseRSSFeeds()
			} catch {
				print("Ошибка при загрузке или разборе RSS: \(error)")
			}
		}
	}
}
