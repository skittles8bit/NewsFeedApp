//
//  TableView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import UIKit

protocol TableViewDelegate: AnyObject {
	func didUpdate()
}

class TableView: UIView {

	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: bounds, style: .plain)
		tableView.backgroundColor = .systemBackground
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
		tableView.refreshControl = refreshControl
		return tableView
	}()

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(didUpdate), for: .valueChanged)
		return refreshControl
	}()

	private var dataSource: UITableViewDiffableDataSource<Int, NewsFeedModelDTO>?

	weak var delegate: TableViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupTableView()
		configureDataSource()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupTableView()
		configureDataSource()
	}

	func updateSnapshot(with items: [NewsFeedModelDTO]) {
		var snapshot = NSDiffableDataSourceSnapshot<Int, NewsFeedModelDTO>()
		snapshot.appendSections([.zero])
		snapshot.appendItems(items)
		dataSource?.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
			guard let self else { return }
			refreshControl.endRefreshing()
		})
	}
}

// MARK: - Private

private extension TableView {

	func setupTableView() {
		addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: topAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}

	func configureDataSource() {
		dataSource = UITableViewDiffableDataSource<Int, NewsFeedModelDTO>(tableView: tableView) { (tableView, indexPath, item) in
			guard
				let cell = tableView.dequeueReusableCell(
					withIdentifier: "NewsCell",
					for: indexPath
				) as? NewsCell
			else {
				return UITableViewCell()
			}
			cell.setup(with: item)
			return cell
		}
	}

	@objc
	func didUpdate() {
		delegate?.didUpdate()
	}
}
