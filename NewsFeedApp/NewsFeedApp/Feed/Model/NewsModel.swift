//
//  NewsModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

struct NewsModel {
	let title: String?
	let description: String?
	let link: String?
	let publicationDate: Date?
	let imageURL: String?
	let channel: String?
}

extension NewsModel: Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(title)
		hasher.combine(description)
		hasher.combine(link)
		hasher.combine(publicationDate)
		hasher.combine(imageURL)
	}
}

extension NewsModel: Equatable {
	static func == (lhs: NewsModel, rhs: NewsModel) -> Bool {
		lhs.title == rhs.title
		&& lhs.description == rhs.description
		&& lhs.link == rhs.link
		&& lhs.publicationDate == rhs.publicationDate
		&& lhs.imageURL == rhs.imageURL
	}
}
