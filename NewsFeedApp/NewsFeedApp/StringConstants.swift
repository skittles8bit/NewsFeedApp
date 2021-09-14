//
//  StringConstants.swift
//  NewsFeedApp
//
//  Created by Alex on 9/12/21.
//

struct StringConstants {
    static let api = "https://newsapi.org/v2/everything?q=apple&from=2021-09-12&to=2021-09-12&sortBy=popularity&apiKey=7e7a5f7c166344cf9f14d4a549ab9282"
    
    static let mainStoryboard = "Main"
    static let newsViewController = "newsViewController"
    static let cellIdentifier = "Cell"
    static let internetConnectionMonitor = "InternetConnectionMonitor"
    
    static let warning = "WARNING!"
    static let error = "Error!"
    static let retry = "RETRY"
    
    static let news = "News"
    static let emptyAuthor = "Empty author"
    static let emptyDescription = "Empty description"
    static let dataLoadingError = "Data loading error. Please try again."
    static let noInternetConnection = "No internet connection. Please try again."
}
