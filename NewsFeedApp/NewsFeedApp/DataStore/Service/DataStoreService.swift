//
//  DataStoreService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import RealmSwift

protocol DataStoreServiceProtocol {
	func getAllNews() -> [NewsModel]?
	func saveNews(with model: NewsModel)
	func updateNews(with id: String, and model: NewsModel)
	func deleteNews(with id: String)
	func claerCache()
	func saveSettings(with model: SettingsModel)
	func getSettings() -> SettingsModel?
}

final class DataStoreService { }

extension DataStoreService: DataStoreServiceProtocol {

	// Получение всех новостей
	func getAllNews() -> [NewsModel]? {
		do {
			let realm = try Realm()
			let newsResults = realm.objects(NewsDataModel.self)
			guard newsResults.count > .zero else { return nil }
			return newsResults.compactMap { model in
				NewsModel(
					title: model.title,
					description: model.subtitle,
					link: model.link,
					publicationDate: model.publicationDate,
					imageURL: model.imageURL,
					channel: model.channel
				)
			}
		} catch {
			print(error)
			return nil
		}
	}

	// Добавление новости
	func saveNews(with model: NewsModel) {
		do {
			let realm = try Realm()
			let news = NewsDataModel()
			news.title = model.title
			news.subtitle = model.description
			news.publicationDate = model.publicationDate
			news.link = model.link
			news.imageURL = model.imageURL
			news.channel = model.channel
			do {
				try realm.write {
					realm.add(news)
				}
			} catch {
				print(error)
			}
		} catch {
			print(error)
		}
	}

	// Обновление новости
	func updateNews(with id: String, and model: NewsModel) {
		do {
			let realm = try Realm()
			guard let newsToUpdate = realm.object(
				ofType: NewsDataModel.self,
				forPrimaryKey: id
			) else {
				return
			}
			do {
				try realm.write {
					newsToUpdate.title = model.title
					newsToUpdate.subtitle = model.description
					newsToUpdate.publicationDate = model.publicationDate
					newsToUpdate.link = model.link
					newsToUpdate.imageURL = model.imageURL
					newsToUpdate.channel = model.channel
				}
			} catch {
				print(error)
			}
		} catch {
			print(error)
		}
	}

	// Удаление новости
	func deleteNews(with id: String) {
		do {
			let realm = try Realm()
			guard let newsToDelete = realm.object(
				ofType: NewsDataModel.self,
				forPrimaryKey: id
			) else {
				return
			}
			do {
				try realm.write {
					realm.delete(newsToDelete)
				}
			} catch {
				print(error)
			}
		} catch {
			print(error)
		}
	}

	func claerCache() {
		ImageLoader.shared.clearCache()
		do {
			let realm = try Realm()
			do {
				try realm.write {
					realm.deleteAll()
				}
			} catch {
				print(error)
			}
		} catch {
			print(error)
		}
	}

	func saveSettings(with model: SettingsModel) {
		do {
			let realm = try Realm()
			let settings = SettingsDataModel()
			settings.hour = model.timerModel.hour
			settings.minute = model.timerModel.minute
			settings.second = model.timerModel.second
			settings.timerEnabled = model.timerEnabled
			do {
				try realm.write {
					realm.add(settings)
				}
			}
		} catch {
			print(error)
		}
	}

	func getSettings() -> SettingsModel? {
		do {
			let realm = try Realm()
			let settings = realm.objects(SettingsDataModel.self).first
			guard let settings else { return nil }
			return SettingsModel(
				timerModel: .init(
					hour: settings.hour,
					minute: settings.minute,
					second: settings.second
				),
				timerEnabled: settings.timerEnabled
			)
		} catch {
			print(error)
			return nil
		}
	}
}
