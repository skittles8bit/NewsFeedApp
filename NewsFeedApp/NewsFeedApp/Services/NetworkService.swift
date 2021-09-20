//
//  NetworkService.swift
//  NewsFeedApp
//
//  Created by Alex on 9/6/21.
//

import Foundation

final class NetworkService {
    
    private let urlAPI = URL(string: API.api)
    private let urlSessionConfiguration = URLSessionConfiguration.default
    
    static let shared = NetworkService()
    
    private init(){
        setupUrlSessionConfiguration()
    }
    
    public func getPosts(completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = urlAPI else {
            return
        }
       
        let session = URLSession(configuration: urlSessionConfiguration)
        
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data{
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    completionHandler(.success(news.articles))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
    
    public func loadImage(viewModel: NewsCellViewModelType?, completionHandler:  @escaping ((Data) -> Void)) {
        
        guard let url = viewModel?.imageUrl else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            completionHandler(data)
        }.resume()
    }
}

private extension NetworkService {
    
    func setupUrlSessionConfiguration(){
        urlSessionConfiguration.waitsForConnectivity = true
        urlSessionConfiguration.timeoutIntervalForResource = 10
    }
}
