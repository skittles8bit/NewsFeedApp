//
//  DateFormatter+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import Foundation

private extension DateFormatter {

	static let newsDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
		return formatter
	}()
}
