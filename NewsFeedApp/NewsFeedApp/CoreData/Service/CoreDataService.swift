//
//  CoreDataService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import CoreData
import UIKit

protocol CoreDataServiceProtocol {
	func saveNews(with model: NewsModel)
	func fetchNews() -> [NewsModel]?
	func deleteNews()
}

final class CoreDataService: CoreDataServiceProtocol {

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "NewsEntity")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error (error), (error.userInfo)")
			}
		})
		return container
	}()

	private var context: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	// Сохранение новости
	func saveNews(with model: NewsModel) {
		let news = NewsEntity(context: context)
		news.title = model.title
		news.subtitle = model.description
		news.publicationDate = model.publicationDate
		news.link = model.link
		news.imageURL = model.imageURL
		news.channel = model.channel
		do {
			try context.save()
		} catch {
			print("Failed to save news: (error)")
		}
	}

	func fetchNews() -> [NewsModel]? {
		let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
		do {
			let news = try context.fetch(fetchRequest)
			return news.compactMap { entity in
				NewsModel(
					title: entity.title,
					description: entity.subtitle,
					link: entity.link,
					publicationDate: entity.publicationDate,
					imageURL: entity.imageURL,
					channel: entity.channel
				)
			}
		} catch {
			print("Failed to fetch news: (error)")
			return nil
		}
	}

	func deleteNews() {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsEntity.fetchRequest()
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print("Failed to delete all news: (error)")
		}
	}
}
