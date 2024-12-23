//
//  NewsSourceViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Combine
import Foundation

typealias NewsSourceViewModelProtocol =
NewsSourceViewModelInputOutput & NewsSourceViewModelActionsAndData

final class NewsSourceViewModel: NewsSourceViewModelProtocol {

	/// Зависимости
	struct Dependencies {
		/// Сервис хранения данных
		let storage: StorageServiceProtocol
	}

	/// Входные данные
	let input: NewsSourceViewModelInput = .init()
	/// Выходные данные
	let output: NewsSourceViewModelOutput = .init()
	/// Данные вью модели
	var data: NewsSourceViewModelData

	private(set) lazy var viewActions = NewsSourceViewModelActions()

	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	private let updateSubject = PassthroughSubject<Void, Never>()

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		self.data = .init(
			updatePublisher: updateSubject.eraseToAnyPublisher(),
			newsSources: []
		)
		bind()
	}
}

private extension NewsSourceViewModel {

	enum Constants {
		static let nytimes = "https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml"
		static let vedomosti = "https://www.vedomosti.ru/rss/news.xml"
		static let cbsnews = "https://www.cbsnews.com/latest/rss/main"
		static let lenta = "https://www.lenta.ru/rss/articles/russia"
	}

	func bind() {
		viewActions.lifecycle
			.receive(on: DispatchQueue.main)
			.sink { [weak self] lifecycle in
				guard let self else { return }
				switch lifecycle {
				case .didLoad,
						.willAppear:
					fetchNewsSource()
				default:
					break
				}
			}.store(in: &subscriptions)
		viewActions.events
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				guard let self else { return }
				switch event {
				case let .didTapAddButton(sourceName):
					addNewsSource(sourceName)
				case let .didTapDelete(index):
					deleteNewsSource(at: index)
				case .didTapSaveOrUpdateButton(let index, let sourceName):
					saveOrUpdateNewsSource(for: index, sourceName: sourceName)
				}
			}.store(in: &subscriptions)
	}

	func fetchNewsSource() {
		let objects = dependencies.storage.fetch(by: NewsSourceObject.self)
			.compactMap {
				NewsSourceModel(id: $0.id, source: $0.name ?? .empty)
			}
		data.newsSources = objects
		updateSubject.send()
	}

	func addNewsSource(_ sourceName: String) {
		let model: NewsSourceModel = .init(
			id: UUID().uuidString,
			source: sourceName
		)
		data.newsSources.append(model)
		dependencies.storage.saveOrUpdate(
			object: NewsSourceObject(id: model.id, name: model.source)
		)
	}

	func saveOrUpdateNewsSource(for index: Int, sourceName: String) {
		data.newsSources[index].source = sourceName
		dependencies.storage.deleteAll(by: NewsSourceObject.self)
		data.newsSources.forEach {
			dependencies.storage.saveOrUpdate(
				object: NewsSourceObject(
					id: $0.id,
					name: $0.source
				)
			)
		}
	}

	func deleteNewsSource(at index: Int) {
		let model = data.newsSources.remove(at: index)
		dependencies.storage.delete(by: NewsSourceObject.self, and: model.id)
	}
}
