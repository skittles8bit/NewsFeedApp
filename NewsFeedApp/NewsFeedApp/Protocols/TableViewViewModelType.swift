//
//  TableViewModelType.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation

protocol TableViewViewModelType {
    var numberOfRows: Int { get }
    func cellViewModel(forIndexPath indexPath : IndexPath) -> TableViewCellViewModelType?
}
