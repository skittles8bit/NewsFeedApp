//
//  ErrorView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import UIKit

/// Делегат вью обработки ошибки
protocol ErrorViewDelegate: AnyObject {
	func update()
}

/// Вью обработки ошибки
final class ErrorView: UIView {

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [title, updateButton])
		stackView.axis = .vertical
		stackView.spacing = 16
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var title: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 24, weight: .semibold)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Ooops...\nЧто-то пошло не так"
		return label
	}()

	private lazy var updateButton: UIButton = {
		let button = UIButton()
		button.setTitle("Попробовать снова", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
		let action = UIAction { [weak self] _ in
			guard let self else { return }
			delegate?.update()
		}
		button.addAction(action, for: .touchUpInside)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		button.backgroundColor = .systemBlue
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	/// Делегат вью
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
		addSubview(stackView)
		backgroundColor = .systemBackground
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
		])
		NSLayoutConstraint.activate([
			updateButton.heightAnchor.constraint(equalToConstant: 50)
		])
	}
}
