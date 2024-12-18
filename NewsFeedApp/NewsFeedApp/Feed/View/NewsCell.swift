//
//  NewsCell.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

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
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private var imageHeightConstraint: NSLayoutConstraint?

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

	func setup(with item: NewsModel) {
		titleLabel.text = item.title
		descriptionLabel.text = item.description
		if let imageURL = item.imageURL {
			newsImageView.image = Constants.placeholderImage
			ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
				guard let self else { return }
				newsImageView.image = image
				imageHeightConstraint?.isActive = true
			}
		} else {
			imageHeightConstraint?.isActive = false
		}
		if let publicationDate = item.publicationDate {
			publicationDateLabel.text = (item.channel ?? "") + " | " + publicationDate.formatted()
		}
	}
}

// MARK: - Private

private extension NewsCell {

	enum Constants {
		static let insent: CGFloat = 10
		static let imageHeight: CGFloat = 300
		static let placeholderImage: UIImage? = UIImage(named: "placeholder-image")
	}

	func setup() {
		selectionStyle = .none
		backgroundColor = .systemBackground
		contentView.addSubview(stackView)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(descriptionLabel)
		stackView.addArrangedSubview(newsImageView)
		stackView.addArrangedSubview(publicationDateLabel)
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
				),
				stackView.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.insent
				),
			]
		)
		imageHeightConstraint = newsImageView.heightAnchor.constraint(
			equalToConstant: Constants.imageHeight
		)
		imageHeightConstraint?.isActive = true
	}
}
