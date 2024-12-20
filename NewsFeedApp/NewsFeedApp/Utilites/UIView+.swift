//
//  UIView+Layout.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

extension UIView {
	/// Добавление нескольких сабвью
	///  - Parameters:
	///   - views: Вьюшки
	func addSubviews(_ views: UIView...) {
		views.forEach { addSubview($0) }
	}
}
