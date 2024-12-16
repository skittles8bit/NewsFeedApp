//
//  String+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import Foundation

extension String {

	var clearString: String {
		self.stripOutHtml.removeControlCharacters.removeWhiteSpaces
	}

	var removeControlCharacters: String {
		self.trimmingCharacters(in: .controlCharacters)
	}

	var removeWhiteSpaces: String {
		self.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	var stripOutHtml: String {
		self.replacingOccurrences(
			of: "<[^>]+>",
			with: "",
			options: .regularExpression,
			range: nil
		)
	}
}
