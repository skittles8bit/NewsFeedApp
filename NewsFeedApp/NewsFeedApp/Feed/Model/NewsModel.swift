//
//  NewsModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Foundation

struct NewsModel {
	let title: String
	let description: String
	let link: String?
	let publicationDate: Date?
	let imageURLs: [String]?
}
