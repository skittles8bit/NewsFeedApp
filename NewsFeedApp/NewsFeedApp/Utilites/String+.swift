//
//  String+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import Foundation

extension String {

	/// Только текст
	var clearString: String {
		self.stripOutHtml.removeControlCharacters.removeWhiteSpaces
	}

	/// Удаляет все управляюшие символы
	var removeControlCharacters: String {
		self.trimmingCharacters(in: .controlCharacters)
	}

	/// Удаляет пробелы и новые строки
	var removeWhiteSpaces: String {
		self.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	/// Удаляет теги HTML
	var stripOutHtml: String {
		self.replacingOccurrences(
			of: "<[^>]+>",
			with: "",
			options: .regularExpression,
			range: nil
		)
	}

	/// " "
	static var space: String {
		" "
	}

	/// ☑
	static var checkMark: String {
		"\u{2611}"
	}

	/// ""
	static var empty: String {
		""
	}

	/// Получение источника
	func extractDomain() -> String? {
		guard let url = URL(string: self) else { return nil }

		// Извлекаем компоненты URL
		let components = URLComponents(
			url: url,
			resolvingAgainstBaseURL: false
		)

		// Проверяем наличие хоста
		if let host = components?.host {
			return host
		}

		return nil
	}
}
