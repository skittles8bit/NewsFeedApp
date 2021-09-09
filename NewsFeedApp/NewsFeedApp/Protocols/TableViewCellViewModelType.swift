//
//  TableViewCellViewModelType.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation

protocol TableViewCellViewModelType: AnyObject {
    var title: String { get }
    var subtitle: String { get }
    var imageUrl: URL? { get }
    var imageData: Data? { get set }
    var url: URL? { get }
    var time: String? { get }
}
