//
//  NewsEntity.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//
//

import Foundation
import CoreData

final class NewsEntity: NSManagedObject, Identifiable {

	@NSManaged var channel: String?
	@NSManaged var imageURL: String?
	@NSManaged var link: String?
	@NSManaged var publicationDate: Date?
	@NSManaged var subtitle: String?
	@NSManaged var title: String?

	@nonobjc class func fetchRequest() -> NSFetchRequest<NewsEntity> {
		return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
	}
}
