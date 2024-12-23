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
			updatePublisher: updateSubject.eraseToAnyPublisher()
		)
		bind()
	}
}

private extension NewsSourceViewModel {

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
					data.newsSources.append(sourceName)
				case let .didTapDelete(index):
					data.newsSources.remove(at: index)
				case .didTapSaveOrUpdateButton(let index, let sourceName):
					data.newsSources[index] = sourceName
				}
				saveNewsSource()
			}.store(in: &subscriptions)
	}

	func fetchNewsSource() {
		let objects = dependencies.storage.fetch(by: NewsSourceObject.self).compactMap { $0.name }
		guard !objects.isEmpty else { return }
		data.newsSources = objects
		updateSubject.send()
	}

	func saveNewsSource() {
		data.newsSources.forEach {
			dependencies.storage.saveOrUpdate(object: NewsSourceObject(name: $0))
		}
	}
}
