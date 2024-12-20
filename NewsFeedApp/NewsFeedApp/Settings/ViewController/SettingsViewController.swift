//
//  SettingsViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

/// Вью контроллер настроек
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
		button.titleLabel?.font = .boldSystemFont(ofSize: 16)
		button.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 10
		button.clipsToBounds = true
		button.setTitleColor(.white, for: .normal)
		return button
	}()

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - viewModel: Вью модель настроек
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

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		viewModel.viewActions.lifecycle.send(.willDisappear)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("SettingViewController deinit")
	}
}

// MARK: - TimerPickerViewDelegate

extension SettingsViewController: TimerPickerViewDelegate {

	func didSelectTimer(period: Int) {
		viewModel.viewActions.events.send(.timerDidChange(period))
	}
}

// MARK: - SettingsCellDelegate

extension SettingsViewController: SettingsCellDelegate {

	func switchValueChanged(_ value: Bool) {
		viewModel.viewActions.events.send(.timerStateDidChange(value))
	}
}

// MARK: - Private

private extension SettingsViewController {

	enum Constants {
		static let insent: CGFloat = 16
		static let buttonHeight: CGFloat = 50
	}

	func setup() {
		view.backgroundColor = .systemBackground
		title = "Настройки"
		stackView.addArrangedSubview(settingsCell)
		stackView.addArrangedSubview(pickerView)
		view.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.insent),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insent),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insent),
		])
		view.addSubview(clearCacheButton)
		NSLayoutConstraint.activate(
			[
				clearCacheButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
				clearCacheButton.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Constants.insent
				),
				clearCacheButton.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -Constants.insent
				),
				clearCacheButton.bottomAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.bottomAnchor,
					constant: -Constants.insent
				)
			]
		)
	}

	func bind() {
		viewModel.data.updateSettingsCellPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				guard let self else { return }
				settingsCell.setup(leftText: model.title, switchValue: model.isEnabled)
			}.store(in: &subscriptions)

		viewModel.data.pickerViewStatePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				guard let self else { return }
				pickerView.alpha = model.isEnabled ? 1 : 0.5
				pickerView.isUserInteractionEnabled = model.isEnabled
				pickerView.setup(with: model.period)
			}.store(in: &subscriptions)
	}

	@objc func clearCache() {
		viewModel.viewActions.events.send(.clearCacheDidTap)
	}
}
