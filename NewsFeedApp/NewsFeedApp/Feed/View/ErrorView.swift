//
//  ErrorView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
	func update()
}

final class ErrorView: UIView {

	private lazy var title: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Ошибка парсинга данных"
		return label
	}()

	private lazy var updateButton: UIButton = {
		let button = UIButton()
		button.setTitle("Попробовать снова", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
		let action = UIAction { [weak self] _ in
			guard let self else { return }
			delegate?.update()
		}
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	weak var delegate: ErrorViewDelegate?

	override init(frame: CGRect) {
		super .init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Private

private extension ErrorView {

	func setup() {
		addSubviews(title, updateButton)
		backgroundColor = .systemBackground
		NSLayoutConstraint.activate([
			title.centerXAnchor.constraint(equalTo: centerXAnchor),
			title.centerYAnchor.constraint(equalTo: centerYAnchor),
			title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
		])
		NSLayoutConstraint.activate([
			updateButton.leadingAnchor.constraint(equalTo: title.leadingAnchor),
			updateButton.trailingAnchor.constraint(equalTo: title.trailingAnchor),
			updateButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20)
		])
	}
}
