//
//  NewsDataModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

class NewsDataModel: Object {

	@objc dynamic var id: String = UUID().uuidString // Уникальный идентификатор
	@objc dynamic var title: String? // Заголовок новости
	@objc dynamic var subtitle: String? // Содержимое новости
	@objc dynamic var publicationDate: Date? // Дата публикации
	@objc dynamic var link: String? // Ссылка на новость
	@objc dynamic var imageURL: String? // Ссылка на картинку
	@objc dynamic var channel: String? // Источник новостей

	override class func primaryKey() -> String? {
		return "id" // Устанавливаем уникальный ключ
	}
}
