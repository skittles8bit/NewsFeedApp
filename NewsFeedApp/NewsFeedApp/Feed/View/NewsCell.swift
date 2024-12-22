//
//  NewsCell.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

/// Ячейка новостной ленты
final class NewsCell: UITableViewCell {

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.numberOfLines = 3
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = 5
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var newsImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 8
		return imageView
	}()

	private lazy var publicationDateLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

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
	}

	/// Настройка ячейки
	///  - Parameters:
	///   - item: Модель данных ленты новостей
	func setup(with model: NewsCellViewModel) {
		guard
			let title = model.item.title,
			let publicationDate = model.item.publicationDate
		else {
			return
		}
		titleLabel.text = title
		if model.isShowDescriptionIsEnabled {
			descriptionLabel.text = model.item.description
		}
		newsImageView.image = Constants.stubImage
		if let imageURL = model.item.imageURL {
			ImageDownloadService.shared.downloadImage(from: imageURL) { [weak self] image in
				guard let self else { return }
				newsImageView.image = image
			}
		}

		let checkMark: String = model.item.isArticleReaded ? .checkMark : .empty
		publicationDateLabel.text = (model.item.channel ?? .empty)
		+ " | "
		+ publicationDate.formatted()
		+ .space
		+ checkMark
	}
}

// MARK: - Private

private extension NewsCell {

	enum Constants {
		static let insent: CGFloat = 16
		static let spacing: CGFloat = 8
		static let imageSize: CGFloat = 70
		static let stubImage: UIImage? = UIImage(named: "placeholder-image")
	}

	func setup() {
		selectionStyle = .none
		backgroundColor = .systemBackground
		contentView.addSubviews(titleLabel, descriptionLabel, publicationDateLabel, newsImageView)
		NSLayoutConstraint.activate(
			[
				titleLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.insent
				),
				titleLabel.topAnchor.constraint(
					equalTo: contentView.topAnchor,
					constant: Constants.insent
				),
				titleLabel.bottomAnchor.constraint(
					equalTo: descriptionLabel.topAnchor,
					constant: -Constants.spacing
				)
			]
		)
		NSLayoutConstraint.activate(
			[
				descriptionLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.insent
				),
				descriptionLabel.trailingAnchor.constraint(
					equalTo: titleLabel.trailingAnchor
				),
				descriptionLabel.bottomAnchor.constraint(
					equalTo: publicationDateLabel.topAnchor,
					constant: -Constants.spacing
				)
			]
		)
		NSLayoutConstraint.activate(
			[
				publicationDateLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.insent
				),
				publicationDateLabel.trailingAnchor.constraint(
					equalTo: descriptionLabel.trailingAnchor
				),
				publicationDateLabel.bottomAnchor.constraint(
					equalTo: contentView.bottomAnchor,
					constant: -Constants.insent
				)
			]
		)
		NSLayoutConstraint.activate(
			[
				newsImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
				newsImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
				newsImageView.leadingAnchor.constraint(
					equalTo: titleLabel.trailingAnchor,
					constant: 8
				),
				newsImageView.centerYAnchor.constraint(
					equalTo: contentView.centerYAnchor
				),
				newsImageView.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.insent
				)
			]
		)
	}
}
