//
//  NetworkService.swift
//  NewsFeedApp
//
//  Created by Alex on 9/6/21.
//

import Foundation

final class NetworkService {
    
    private let urlAPI = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2021-08-07&sortBy=publishedAt&apiKey=7e7a5f7c166344cf9f14d4a549ab9282")
    
    static let shared = NetworkService()
    
    private init(){}
    
    public func getPosts(complitionHandler: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = urlAPI else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                complitionHandler(.failure(error))
            } else if let data = data{
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    complitionHandler(.success(news.articles))
                } catch {
                    complitionHandler(.failure(error))
                }
            }
        }.resume()
    }
    
}
