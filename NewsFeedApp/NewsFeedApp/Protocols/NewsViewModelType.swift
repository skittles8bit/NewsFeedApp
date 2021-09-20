//
//  TableViewModelType.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation

protocol NewsViewModelType {
    var numberOfRows: Int { get }
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsCellViewModelType?
}
