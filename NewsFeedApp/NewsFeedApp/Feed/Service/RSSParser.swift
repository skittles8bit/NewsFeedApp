//
//  RSSParser.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Foundation

protocol RSSParserProtocol {
	var items: [NewsModel] { get }
	func parseRSS(at urlString: String) async throws
}

final class RSSParser: NSObject {

	private var currentElement = ""
	private var currentTitle: String?
	private var currentDescription: String?
	private var currentLink: String?
	private var imageURLs: [String] = []
	private var currentPubDate: Date?

	var items = [NewsModel]()
}

extension RSSParser: RSSParserProtocol {

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

extension RSSParser: XMLParserDelegate {

	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String]
	) {
		currentElement = elementName
		if currentElement == "item" {
			currentTitle = nil
			currentDescription = nil
			currentLink = nil
			currentPubDate = nil
		} else if currentElement == "enclosure" {
			if let urlString = attributeDict["url"] {
				imageURLs.append(urlString)
			}
		}
	}

	func parser(
		_ parser: XMLParser,
		foundCharacters string: String
	) {
		switch currentElement {
		case "title":
			currentTitle?.append(string)
		case "description":
			currentDescription?.append(string)
		case "link":
			currentLink?.append(string)
		case "pubDate":
			currentPubDate = DateFormatter.newsDateFormatter.date(from: string)
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
		if elementName == "item" {
			guard
				let title = currentTitle,
				let description = currentDescription
			else {
				return
			}
			let item = NewsModel(
				title: title,
				description: description,
				link: currentLink,
				publicationDate: currentPubDate,
				imageURLs: imageURLs
			)
			items.append(item)
		}
	}
}

private extension DateFormatter {

	static let newsDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
		return formatter
	}()
}
