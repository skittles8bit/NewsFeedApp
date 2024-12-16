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
	let publicationDate: String?
	let imageURL: String?
	var image: UIImage?
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
