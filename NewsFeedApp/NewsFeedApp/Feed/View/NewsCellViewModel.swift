//
//  NewsCellViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 22.12.24.
//

import Foundation

/// Модель данных для ячейки новостей
struct NewsCellViewModel {

	/// Айтем новостей
	let item: NewsFeedModelDTO
	/// Доступено ли описание
	let isShowDescriptionIsEnabled: Bool
}

// MARK: - Hashable

extension NewsCellViewModel: Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(item)
		hasher.combine(isShowDescriptionIsEnabled)
	}
}
