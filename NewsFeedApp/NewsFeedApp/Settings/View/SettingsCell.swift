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
	///   - value: Значение
	func switchValueChanged(_ value: Bool)
}

/// Ячейка настроек
final class SettingsCell: UIView {

	private lazy var leftLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .boldSystemFont(ofSize: 14)
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

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [leftLabel, switchControl])
		stackView.distribution = .equalSpacing
		return stackView
	}()

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
	func setup(leftText: String, switchValue: Bool) {
		leftLabel.text = leftText
		switchControl.isOn = switchValue
	}
}

// MARK: - Private

private extension SettingsCell {

	func setup() {
		addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	@objc
	func switchValueChanged(switchControl: UISwitch) {
		delegate?.switchValueChanged(switchControl.isOn)
	}
}
