//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Alexander Karenski on 6.09.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPost()
    }
    
    private func getPost() {
        NetworkService.shared.getPosts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let news):
                self.viewModels = news.compactMap({
                    NewsTableViewCellViewModel(title: $0.author ?? "Empty author",
                                               subtitle: $0.description ?? "Empty description",
                                               imageUrl: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NewsTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
