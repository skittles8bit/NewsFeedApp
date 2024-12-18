//
//  SettingsViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

final class SettingsViewController: UIViewController {

	private let viewModel: SettingsViewModelActionsAndData

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var settingsCell: SettingsCell = {
		let cell = SettingsCell()
		cell.translatesAutoresizingMaskIntoConstraints = false
		cell.delegate = self
		return cell
	}()

	private lazy var pickerView: TimerPickerView = {
		let pickerView = TimerPickerView()
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		pickerView.backgroundColor = .systemBackground
		pickerView.delegate = self
		return pickerView
	}()

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

	private var subscriptions = Subscriptions()

	init(viewModel: SettingsViewModelActionsAndData) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.viewActions.lifecycle.send(.didLoad)
		setup()
		bind()
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

extension SettingsViewController: SettingsCellDelegate {

	func switchValueChanged(_ value: Bool) {
		viewModel.viewActions.events.send(.timerStateDidChange(value))
	}
}

private extension SettingsViewController {

	func setup() {
		view.backgroundColor = .systemBackground
		title = "Настройки"
		navigationController?.navigationBar.tintColor = .black
		stackView.addArrangedSubview(settingsCell)
		stackView.addArrangedSubview(pickerView)
		view.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
		])
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

	func bind() {
		viewModel.data.switchStatePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isEnabled in
				guard let self else { return }
				settingsCell.setup(switchValue: isEnabled)
			}.store(in: &subscriptions)

		viewModel.data.pickerViewStatePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isEnabled in
				guard let self else { return }
				pickerView.alpha = isEnabled ? 1 : 0.5
				pickerView.isUserInteractionEnabled = isEnabled
			}.store(in: &subscriptions)
	}

	@objc func clearCache() {
		viewModel.viewActions.events.send(.clearCacheDidTap)
	}
}
