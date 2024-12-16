//
//  LoadView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import UIKit

final class LoadView: UIView {

	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.color = .white
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()

	override init(frame: CGRect) {
		super .init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func startAnimation() {
		activityIndicator.startAnimating()
	}

	func stopAnimation() {
		activityIndicator.stopAnimating()
	}
}

private extension LoadView {

	func setup() {
		addSubview(activityIndicator)
		activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		backgroundColor = .darkGray.withAlphaComponent(0.5)
		startAnimation()
	}
}
