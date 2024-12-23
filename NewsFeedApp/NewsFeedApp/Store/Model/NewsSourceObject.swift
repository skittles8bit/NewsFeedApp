//
//  NewsSourceObject.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import RealmSwift

final class NewsSourceObject: Object {

	@Persisted(primaryKey: true) var id: String = UUID().uuidString
	@Persisted var name: String?
}

extension NewsSourceObject {
	convenience init(name: String) {
		self.init()
		self.name = name
	}
}
