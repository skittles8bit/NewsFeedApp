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

	private lazy var updateNewsSettingCell: SettingsCell = {
		let cell = SettingsCell()
		cell.delegate = self
		return cell
	}()

	private lazy var showDescriptionSettingsCell: SettingsCell = {
		let cell = SettingsCell()
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
		button.setTitle(Constants.buttonTitle, for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 16)
		let action = UIAction { [weak self] _ in
			guard let self else { return }
			viewModel.viewActions.events.send(.clearCacheDidTap)
		}
		button.addAction(action, for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 10
		button.clipsToBounds = true
		button.setTitleColor(.white, for: .normal)
		return button
	}()

	private lazy var newsSourceCell: SettingsCell = {
		let cell = SettingsCell()
		cell.delegate = self
		return cell
	}()

	private lazy var newsSourceButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Источник новостей", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 16)
		let action = UIAction { [weak self] _ in
			guard let self else { return }
			viewModel.viewActions.events.send(.newsSourceDidTap)
		}
		button.addAction(action, for: .touchUpInside)
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

	func switchValueChanged(
		type: SettingsCellViewModel.SettingsCellType?,
		isOn: Bool
	) {
		guard let type else { return }
		viewModel.viewActions.events.send(.settingsToggleDidChange(type, isOn))
	}
}

// MARK: - Private

private extension SettingsViewController {

	enum Constants {
		static let inset: CGFloat = 16
		static let buttonHeight: CGFloat = 50
		static let title: String = "Настройки"
		static let buttonTitle: String = "Очистить кеш"
	}

	func setup() {
		view.backgroundColor = .systemBackground
		title = Constants.title
		view.addSubviews(stackView, newsSourceButton, clearCacheButton)
		stackView.addArrangedSubview(updateNewsSettingCell)
		stackView.addArrangedSubview(pickerView)
		stackView.addArrangedSubview(showDescriptionSettingsCell)
		stackView.addArrangedSubview(newsSourceCell)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.inset),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.inset),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.inset),
		])
		NSLayoutConstraint.activate([
			newsSourceButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
			newsSourceButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
			newsSourceButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
			newsSourceButton.topAnchor.constraint(
				equalTo: stackView.bottomAnchor,
				constant: Constants.inset
			)
		])
		NSLayoutConstraint.activate(
			[
				clearCacheButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
				clearCacheButton.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: Constants.inset
				),
				clearCacheButton.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -Constants.inset
				),
				clearCacheButton.bottomAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.bottomAnchor,
					constant: -Constants.inset
				)
			]
		)
	}

	func bind() {
		viewModel.data.updateSettingsCellPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] models in
				guard let self else { return }
				setupSettingCells(with: models)
			}.store(in: &subscriptions)

		viewModel.data.pickerViewStatePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				guard let self else { return }
				pickerView.alpha = model.isEnabled ? 1 : 0.5
				pickerView.isUserInteractionEnabled = model.isEnabled
				pickerView.setup(with: model.period)
			}.store(in: &subscriptions)

		viewModel.data.newsSourceButtonStatePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isEnabled in
				guard let self else { return }
				newsSourceButton.alpha = isEnabled ? 1 : 0.5
				newsSourceButton.isUserInteractionEnabled = isEnabled
			}.store(in: &subscriptions)
	}

	func setupSettingCells(with models: [SettingsCellViewModel]) {
		models.forEach { [weak self] in
			guard let self else { return }
			switch $0.type {
			case .timer:
				updateNewsSettingCell.setup(with: $0)
			case .description:
				showDescriptionSettingsCell.setup(with: $0)
			case .newsSource:
				newsSourceCell.setup(with: $0)
			}
		}
	}
}
