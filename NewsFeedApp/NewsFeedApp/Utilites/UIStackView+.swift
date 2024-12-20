//
//  UIStackView+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

extension UIStackView {

	/// Добавления нескольких сабвью
	///   - Parameters:
	///    - views: Вьюшки
	func addArrangedSubviews(_ views: UIView...) {
		views.forEach { addArrangedSubview($0) }
	}
}
