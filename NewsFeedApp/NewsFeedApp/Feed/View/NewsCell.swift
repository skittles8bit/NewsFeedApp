//
//  NewsCell.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

final class NewsCell: UITableViewCell {

	private lazy var image: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()

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

	private lazy var publicationDateLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
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

	func setup(with item: NewsModel) {
		stackView.subviews.forEach { $0.removeFromSuperview() }
		selectionStyle = .none

		titleLabel.text = item.title
		image.image = item.image
		descriptionLabel.text = item.description

		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(descriptionLabel)
		stackView.addArrangedSubview(image)
		stackView.addArrangedSubview(publicationDateLabel)

		if let publicationDate = item.publicationDate, !publicationDate.isEmpty {
			publicationDateLabel.text = publicationDate
		}
	}
}

// MARK: - Private

private extension NewsCell {

	func setup() {
		backgroundColor = .systemBackground
		contentView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
		])
		NSLayoutConstraint.activate([
			image.heightAnchor.constraint(equalToConstant: 300)
		])
	}
}
