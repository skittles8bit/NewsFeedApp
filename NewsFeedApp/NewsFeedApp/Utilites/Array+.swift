//
//  Array+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Foundation

extension Sequence where Element: Hashable {

	/// Уникальные эдементы в массиве
	///  - returns: Уникальные элементы
	func uniqued() -> [Element] {
		var set = Set<Element>()
		return filter { set.insert($0).inserted }
	}
}

extension Array where Element == NewsFeedModelDTO {

	func sortNews() -> [NewsFeedModelDTO] {
		self.sorted { prev, curr in
			guard
				let prevPublicationDate = prev.publicationDate,
				let currPublicationDate = curr.publicationDate
			else {
				return false
			}
			return prevPublicationDate > currPublicationDate
		}
	}
}
