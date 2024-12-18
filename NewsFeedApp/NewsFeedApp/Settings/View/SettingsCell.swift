//
//  SettingsCell.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
	func switchValueChanged(_ value: Bool)
}

final class SettingsCell: UIView {

	private lazy var leftLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.text = "Активировать обновление новостей \nпо таймеру"
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .left
		label.numberOfLines = 0
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

	weak var delegate: SettingsCellDelegate?

	override init(frame: CGRect) {
		super .init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup(switchValue: Bool) {
		switchControl.isOn = switchValue
	}
}

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
