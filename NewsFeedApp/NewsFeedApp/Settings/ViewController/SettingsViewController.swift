//
//  SettingsViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

final class SettingsViewController: UIViewController {

	private let viewModel: SettingsViewModelActionsAndData

	private lazy var clearCacheButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Очистить кеш", for: .normal)
		button.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	init(viewModel: SettingsViewModelActionsAndData) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension SettingsViewController {

	func setup() {
		view.backgroundColor = .systemBackground
		title = "Настройки"
		navigationController?.navigationBar.tintColor = .black
		view.addSubview(clearCacheButton)
		NSLayoutConstraint.activate(
			[
				clearCacheButton.heightAnchor.constraint(equalToConstant: 100),
				clearCacheButton.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: 10
				),
				clearCacheButton.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -10
				),
				clearCacheButton.bottomAnchor.constraint(
					equalTo: view.bottomAnchor,
					constant: -10
				),
			]
		)
	}

	@objc func clearCache() {
		viewModel.viewActions.events.send(.clearCacheDidTap)
	}
}
