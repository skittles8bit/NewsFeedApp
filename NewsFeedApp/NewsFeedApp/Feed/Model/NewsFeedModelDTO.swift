//
//  NewsFeedModelDTO.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

struct NewsFeedModelDTO {

	let id: String
	let title: String?
	let description: String?
	let link: String?
	let publicationDate: Date?
	let imageURL: String?
	let channel: String?
	var isArticleReaded: Bool
	var isDescriptionExpanded: Bool
}

extension NewsFeedModelDTO {

	init(from object: NewsFeedObject) {
		id = object.id
		title = object.title
		description = object.subtitle
		link = object.link
		publicationDate = object.publicationDate
		imageURL = object.imageURL
		channel = object.channel
		isArticleReaded = object.isArticleReaded
		isDescriptionExpanded = object.isDescriptionExpanded
	}
}

extension NewsFeedModelDTO: Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(title)
		hasher.combine(description)
		hasher.combine(link)
		hasher.combine(publicationDate)
		hasher.combine(imageURL)
	}
}

extension NewsFeedModelDTO: Equatable {

	static func == (lhs: NewsFeedModelDTO, rhs: NewsFeedModelDTO) -> Bool {
		lhs.title == rhs.title
		&& lhs.description == rhs.description
		&& lhs.link == rhs.link
		&& lhs.publicationDate == rhs.publicationDate
		&& lhs.imageURL == rhs.imageURL
	}
}
