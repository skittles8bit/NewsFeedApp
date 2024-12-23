//
//  NewsSourceObject.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Foundation
import RealmSwift

final class NewsSourceObject: Object {

	@Persisted(primaryKey: true) var id: String = UUID().uuidString
	@Persisted var name: String?
}

extension NewsSourceObject {

	convenience init(id: String, name: String) {
		self.init()
		self.id = id
		self.name = name
	}
}
