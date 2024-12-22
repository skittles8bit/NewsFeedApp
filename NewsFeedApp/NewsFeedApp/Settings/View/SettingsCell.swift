//
//  SettingsCell.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import UIKit

/// Делегат ячейки настроек
protocol SettingsCellDelegate: AnyObject {
	/// Значение тоггла изменено
	///  - Parameters:
	///   - type: Тип ячейки
	///   - isOn: Значение тоггла
	func switchValueChanged(
		type: SettingsCellViewModel.SettingsCellType?,
		isOn: Bool
	)
}

struct SettingsCellViewModel {

	enum SettingsCellType {
		case timer
		case description
		case newsSource
	}

	let title: String
	let subtitle: String?
	let isOn: Bool
	let type: SettingsCellType
}

/// Ячейка настроек
final class SettingsCell: UIView {

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .left
		label.numberOfLines = .zero
		return label
	}()

	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .secondaryLabel
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .left
		label.numberOfLines = .zero
		return label
	}()

	private lazy var switchControl: UISwitch = {
		let switchControl = UISwitch()
		switchControl.isOn = false
		switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
		return switchControl
	}()

	private lazy var leftStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 8
		return stackView
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [leftStackView, switchControl])
		stackView.distribution = .equalSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 16
		return stackView
	}()

	private var model: SettingsCellViewModel?

	/// Делегат ячейки
	weak var delegate: SettingsCellDelegate?

	override init(frame: CGRect) {
		super .init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Настройка ячейки
	///  - Parameters:
	///   - leftText: Текст для левого лейбла
	///   - switchValue: Значение тоггла
	func setup(with model: SettingsCellViewModel?) {
		guard let model else { return }
		self.model = model
		titleLabel.text = model.title
		subtitleLabel.text = model.subtitle
		switchControl.isOn = model.isOn
	}
}

// MARK: - Private

private extension SettingsCell {

	func setup() {
		addSubview(stackView)
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	@objc
	func switchValueChanged(switchControl: UISwitch) {
		delegate?.switchValueChanged(type: model?.type, isOn: switchControl.isOn)
	}
}
