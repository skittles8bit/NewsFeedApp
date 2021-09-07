//
//  News.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import Foundation

struct News: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
