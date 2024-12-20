//
//  NewsCell.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

/// Делегат ячейки ленты новостей
protocol NewsCellDelegate: AnyObject {
	/// Нажата кнопка Показать описание
	///  - Parameters:
	///   - cell: Ячейка новостной ленты
	func didTapShowMoreInfoButton(for cell: NewsCell)
}

/// Ячейка новостной ленты
final class NewsCell: UITableViewCell {

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.numberOfLines = .zero
		return label
	}()

	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = .zero
		return label
	}()

	private lazy var showMoreInfoButton: UIButton = {
		let button = UIButton()
		button.setTitle("Показать описание", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
		let action = UIAction { [weak self] _ in
			guard let self else { return }
			descriptionLabel.isHidden = false
			showMoreInfoButton.isHidden = true
			delegate?.didTapShowMoreInfoButton(for: self)
		}
		button.addAction(action, for: .touchUpInside)
		return button
	}()

	private lazy var newsImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private lazy var publicationDateLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .bold)
		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 4
		stackView.distribution = .fillProportionally
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var mainStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 8
		stackView.distribution = .fillProportionally
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private var stackViewTrailingConstraint: NSLayoutConstraint?

	/// Делегат ячейки
	weak var delegate: NewsCellDelegate?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		titleLabel.text = nil
		descriptionLabel.text = nil
		newsImageView.image = nil
		publicationDateLabel.text = nil
		showMoreInfoButton.isHidden = true
		descriptionLabel.isHidden = true
	}

	/// Настройка ячейки
	///  - Parameters:
	///   - item: Модель данных ленты новостей
	func setup(with item: NewsFeedModelDTO) {
		titleLabel.text = item.title
		descriptionLabel.text = item.description
		showMoreInfoButton.isHidden = item.description == .empty || item.isDescriptionExpanded
		descriptionLabel.isHidden = !item.isDescriptionExpanded
		if let imageURL = item.imageURL {
			newsImageView.setImage(from: imageURL)
		} else {
			stackViewTrailingConstraint = stackView.trailingAnchor.constraint(
				equalTo: contentView.trailingAnchor,
				constant: -Constants.insent
			)
			stackViewTrailingConstraint?.isActive = true
			newsImageView.constraints.forEach { $0.isActive = false }
		}
		if let publicationDate = item.publicationDate {
			let checkMark: String = item.isArticleReaded ? .checkMark : .empty
			publicationDateLabel.text = (item.channel ?? .empty)
			+ " | "
			+ publicationDate.formatted()
			+ .space
			+ checkMark
		}
	}
}

// MARK: - Private

private extension NewsCell {

	enum Constants {
		static let insent: CGFloat = 16
		static let imageSize: CGFloat = 70
	}

	func setup() {
		selectionStyle = .none
		backgroundColor = .systemBackground
		contentView.addSubviews(stackView, newsImageView)
		stackView.addArrangedSubviews(
			titleLabel,
			descriptionLabel,
			showMoreInfoButton,
			publicationDateLabel
		)
		NSLayoutConstraint.activate(
			[
				stackView.topAnchor.constraint(
					equalTo: contentView.topAnchor,
					constant: Constants.insent
				),
				stackView.bottomAnchor.constraint(
					equalTo: contentView.bottomAnchor,
					constant: -Constants.insent
				),
				stackView.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.insent
				)
			]
		)
		NSLayoutConstraint.activate(
			[
				newsImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
				newsImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
				newsImageView.leadingAnchor.constraint(
					equalTo: stackView.trailingAnchor,
					constant: 8
				),
				newsImageView.centerYAnchor.constraint(
					equalTo: stackView.centerYAnchor
				),
				newsImageView.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.insent
				),
			]
		)
	}
}
