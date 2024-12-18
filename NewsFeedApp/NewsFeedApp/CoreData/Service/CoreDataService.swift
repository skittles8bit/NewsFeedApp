//
//  CoreDataService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

//import Foundation
//import CoreData
//import UIKit
//
//protocol CoreDataServiceProtocol {
//	func saveNews(title: String, content: String)
//	func fetchNews() -> [NewsEntities]
//	func deleteNews()
//}
//
//final class CoreDataService {
//
//	private lazy var persistentContainer: NSPersistentContainer = {
//		let container = NSPersistentContainer(name: "NewsEntities")
//		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//			if let error = error as NSError? {
//				fatalError("Unresolved error (error), (error.userInfo)")
//			}
//		})
//		return container
//	}()
//
//	private var context: NSManagedObjectContext {
//		return persistentContainer.viewContext
//	}
//
//	// Сохранение новости
//	func saveNews(with model: NewsModel) {
//		let news = NewsEntities(context: context)
//		news.title = model.title
//		news.subtitle = model.description
//		news.publicationDate = model.publicationDate?.formatted()
//		do {
//			try context.save()
//		} catch {
//			print("Failed to save news: (error)")
//		}
//	}
//
//	func fetchAllNews() -> [NewsEntities]? {
//		let fetchRequest: NSFetchRequest<NewsEntities> = NewsEntities.fetchRequest()
//		do {
//			return try context.fetch(fetchRequest)
//		} catch {
//			print("Failed to fetch news: (error)")
//			return nil
//		}
//	}
//
//	func deleteNews() {
//		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsEntities.fetchRequest()
//		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//		do {
//			try context.execute(deleteRequest)
//			try context.save()
//		} catch {
//			print("Failed to delete all news: (error)")
//		}
//	}
//}
