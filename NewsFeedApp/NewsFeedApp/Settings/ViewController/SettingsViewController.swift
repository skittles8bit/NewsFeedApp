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
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 10
		button.clipsToBounds = true
		button.setTitleColor(.white, for: .normal)
		return button
	}()

	private lazy var pickerView: TimerPickerView = {
		let pickerView = TimerPickerView()
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		pickerView.backgroundColor = .systemBackground
		pickerView.delegate = self
		return pickerView
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

extension SettingsViewController: TimerPickerViewDelegate {

	func didSelectTimer(model: TimeIntervalModel) {
		viewModel.viewActions.events.send(.timerDidChange(model))
	}
}

private extension SettingsViewController {

	func setup() {
		view.backgroundColor = .systemBackground
		title = "Настройки"
		navigationController?.navigationBar.tintColor = .black
		view.addSubview(pickerView)
		NSLayoutConstraint.activate(
			[
				pickerView.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: 10
				),
				pickerView.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -10
				),
				pickerView.topAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.topAnchor,
					constant: 10
				),
				pickerView.heightAnchor.constraint(equalToConstant: 150)
			]
		)
		view.addSubview(clearCacheButton)
		NSLayoutConstraint.activate(
			[
				clearCacheButton.heightAnchor.constraint(equalToConstant: 50),
				clearCacheButton.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: 10
				),
				clearCacheButton.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -10
				),
				clearCacheButton.bottomAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.bottomAnchor,
					constant: -10
				),
			]
		)
	}

	@objc func clearCache() {
		viewModel.viewActions.events.send(.clearCacheDidTap)
	}
}
