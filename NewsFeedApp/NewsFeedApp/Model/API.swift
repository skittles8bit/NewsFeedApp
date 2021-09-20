//
//  API.swift
//  NewsFeedApp
//
//  Created by Alex on 9/14/21.
//

import Foundation

struct API {
    
    static let api = "https://newsapi.org/v2/top-headlines?country=\((Locale.current.regionCode?.lowercased()) ?? "en")&category=business&apiKey=7e7a5f7c166344cf9f14d4a549ab9282"
}
