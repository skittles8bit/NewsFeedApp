//
//  RSSParser.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Foundation

/// Протокол парсера RSS
protocol RSSParserServiceProtocol {
	var items: [NewsFeedModelDTO] { get }
	func parseRSS(at urlString: String) async throws
}

/// Парсер данных RSS
final class RSSParserService: NSObject {

	private var currentElement = ""
	private var currentTitle = ""
	private var currentDescription = ""
	private var currentLink = ""
	private var currentImageURL: String?
	private var currentPubDate: Date?

	/// Новости
	var items = [NewsFeedModelDTO]()
}

// MARK: - RSSParserServiceProtocol

extension RSSParserService: RSSParserServiceProtocol {

	func parseRSS(at urlString: String) async throws {
		guard let url = URL(string: urlString) else {
			throw URLError(.badURL)
		}

		let (data, _) = try await URLSession.shared.data(from: url)
		let parser = XMLParser(data: data)
		parser.delegate = self
		parser.parse()
	}
}

// MARK: - XMLParserDelegate

extension RSSParserService: XMLParserDelegate {

	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String]
	) {
		currentElement = elementName
		switch currentElement {
		case RSSTagNames.item.rawValue:
			currentTitle = .empty
			currentDescription = .empty
			currentLink = .empty
			currentImageURL = nil
			currentPubDate = nil
		case RSSTagNames.enclosure.rawValue:
			if let urlString = attributeDict["url"] {
				currentImageURL = urlString
			}
		case RSSTagNames.mediaContent.rawValue:
			if let urlString = attributeDict["url"] {
				currentImageURL = urlString
			}
		default:
			break
		}
	}

	func parser(
		_ parser: XMLParser,
		foundCharacters string: String
	) {
		switch currentElement {
		case RSSTagNames.title.rawValue:
			currentTitle.append(string)
		case RSSTagNames.description.rawValue:
			currentDescription.append(string)
		case RSSTagNames.link.rawValue:
			currentLink.append(string)
		case RSSTagNames.pubDate.rawValue:
			guard !string.clearString.isEmpty else { return }
			currentPubDate = DateFormatter.newsDateFormatter.date(from: string)
		case RSSTagNames.image.rawValue:
			guard currentImageURL == nil else {
				return
			}
			currentImageURL = string
		default:
			break
		}
	}

	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?
	) {
		switch elementName {
		case RSSTagNames.item.rawValue:
			let item = NewsFeedModelDTO(
				id: UUID().uuidString,
				title: currentTitle.clearString,
				description: currentDescription.clearString,
				link: currentLink.clearString,
				publicationDate: currentPubDate,
				imageURL: currentImageURL?.clearString,
				channel: currentLink.clearString.extractDomain() ?? "",
				isArticleReaded: false
			)
			items.append(item)
		default:
			break
		}
	}
}

// MARK: - Private

private extension RSSParserService {

	enum RSSTagNames: String {
		case item
		case title
		case link
		case comments
		case pubDate
		case description
		case enclosure
		case mediaContent = "media:content"
		case channel
		case guid
		case image
	}
}
