//
//  NewsFeedObject.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation
import RealmSwift

final class NewsFeedObject: Object {

	@Persisted(primaryKey: true) var id: String = UUID().uuidString // Уникальный идентификатор
	@Persisted var title: String? // Заголовок новости
	@Persisted var subtitle: String? // Содержимое новости
	@Persisted var publicationDate: Date? // Дата публикации
	@Persisted var link: String? // Ссылка на новость
	@Persisted var imageURL: String? // Ссылка на картинку
	@Persisted var channel: String? // Источник новостей
	@Persisted var isArticleReaded: Bool = false // Прочитана ли статья
}

extension NewsFeedObject {

	convenience init(from newsFeed: NewsFeedModelDTO) {
		self.init()
		id = newsFeed.id
		title = newsFeed.title
		subtitle = newsFeed.description
		publicationDate = newsFeed.publicationDate
		link = newsFeed.link
		imageURL = newsFeed.imageURL
		channel = newsFeed.channel
		isArticleReaded = newsFeed.isArticleReaded
	}
}
