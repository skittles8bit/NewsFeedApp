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
		label.numberOfLines = 0
		return label
	}()

	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = 0
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

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		titleLabel.text = nil
		newsImageView.image = nil
		descriptionLabel.text = nil
	}

	func setup(with item: NewsModel) {
		titleLabel.text = item.title
		if let imageURL = item.imageURL {
			ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
				guard let self else { return }
				newsImageView.image = image
			}
		}
		descriptionLabel.text = item.description

		let channel = item.link?.extractDomain(from: item.link ?? "") ?? ""

		if let publicationDate = item.publicationDate {
			publicationDateLabel.text = channel + " | " + publicationDate.formatted()
		}
	}
}

// MARK: - Private

private extension NewsCell {

	enum Constants {
		static let insent: CGFloat = 10
		static let imageHeight: CGFloat = 300
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
		NSLayoutConstraint.activate([
			newsImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
		])
	}
}