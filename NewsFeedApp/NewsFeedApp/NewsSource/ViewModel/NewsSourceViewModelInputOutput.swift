//
//  NewsSourceViewModelInputOutput.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Foundation

/// Протокол входных и выходных данных
protocol NewsSourceViewModelInputOutput {
	/// Входные данные
	var input: NewsSourceViewModelInput { get }
	/// Выходные данные
	var output: NewsSourceViewModelOutput { get }
}

/// Структура входных данных
struct NewsSourceViewModelInput {}

/// Структура выходных данных
struct NewsSourceViewModelOutput { }
