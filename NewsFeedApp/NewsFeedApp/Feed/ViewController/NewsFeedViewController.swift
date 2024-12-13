//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

final class NewsFeedViewController: UIViewController {

	private let viewModel: NewsFeedViewModel

	init(with viewModel: NewsFeedViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.viewActions.lifecycle.send(.didLoad)
	}
}

private extension NewsFeedViewController {
}

