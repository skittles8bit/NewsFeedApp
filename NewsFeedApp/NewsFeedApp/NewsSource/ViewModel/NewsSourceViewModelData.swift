//
//  NewsSourceViewModelData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Combine
import UIKit

struct NewsSourceModel {

	let id: String
	var source: String
}

struct NewsSourceViewModelData {

	let updatePublisher: AnyPublisher<Void, Never>
	var newsSources: [NewsSourceModel]
}
