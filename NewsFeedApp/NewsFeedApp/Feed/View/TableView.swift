//
//  TableView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import UIKit

/// Делегат таблицы
protocol TableViewDelegate: AnyObject {
	/// Обновление таблицы
	func didUpdate()
	/// Нажата ячейка
	///  - Parameters:
	///   - index: Индекс ячейки
	func didTap(with index: Int)
}

/// Класс кастомной таблицы
final class TableView: UIView {

	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: bounds, style: .plain)
		tableView.backgroundColor = .systemBackground
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
		tableView.refreshControl = refreshControl
		tableView.delegate = self
		return tableView
	}()

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		let action = UIAction { [weak self] _ in
			guard let self else { return }
			delegate?.didUpdate()
		}
		refreshControl.addAction(action, for: .valueChanged)
		return refreshControl
	}()

	private var dataSource: UITableViewDiffableDataSource<Int, NewsCellViewModel>?
	private var imageLoaderList = [UITableViewCell: ImageLoader]()

	/// Делегат таблицы
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

	/// Применить изменения
	///  - Parameters:
	///   - items: Массив моделей ленты новостей
	func applySnapshot(with items: [NewsCellViewModel]) {
		var snapshot = NSDiffableDataSourceSnapshot<Int, NewsCellViewModel>()
		snapshot.appendSections([.zero])
		snapshot.appendItems(items)
		dataSource?.apply(
			snapshot,
			animatingDifferences: true,
			completion: { [weak self] in
				guard let self else { return }
				refreshControl.endRefreshing()
			}
		)
	}

	/// Перезагрузить таблицу
	func reloadTableView() {
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate

extension TableView: UITableViewDelegate {

	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		delegate?.didTap(with: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		UITableView.automaticDimension
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

	func getImageLoaderList(forReusableCell cell: UITableViewCell) -> ImageLoader {
		guard let loader = imageLoaderList[cell] else {
			let loader = ImageLoader()
			imageLoaderList[cell] = loader
			return loader
		}
		return loader
	}

	func configureDataSource() {
		dataSource = UITableViewDiffableDataSource<Int, NewsCellViewModel>(tableView: tableView) { [weak self] (tableView, indexPath, item) in
			guard
				let self,
				let cell = tableView.dequeueReusableCell(
					withIdentifier: "NewsCell",
					for: indexPath
				) as? NewsCell
			else {
				return UITableViewCell()
			}
			let loader = getImageLoaderList(forReusableCell: cell)
			cell.setup(with: item)
			loader.configure(from: item.item.imageURL ?? .empty) { image in
				cell.newsImageView.image = image
			}
			return cell
		}
		dataSource?.defaultRowAnimation = .fade
	}

	@objc
	func didUpdate() {
		delegate?.didUpdate()
	}
}
