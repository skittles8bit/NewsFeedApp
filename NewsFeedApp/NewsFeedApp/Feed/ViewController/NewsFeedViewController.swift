//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

final class NewsFeedViewController: UIViewController {

	private let viewModel: NewsFeedViewModel

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .systemBackground
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
		tableView.refreshControl = refreshControl
		return tableView
	}()

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return refreshControl
	}()

	private lazy var loadView: LoadView = {
		let loadView = LoadView()
		loadView.translatesAutoresizingMaskIntoConstraints = false
		return loadView
	}()

	private lazy var errorView: ErrorView = {
		let errorView = ErrorView()
		errorView.translatesAutoresizingMaskIntoConstraints = false
		errorView.isHidden = true
		errorView.delegate = self
		return errorView
	}()

	private var subscriptions = Subscriptions()

	init(with viewModel: NewsFeedViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.viewActions.lifecycle.send(.didLoad)
		setup()
		bind()
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return viewModel.newsFeedItems.count
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "NewsCell",
				for: indexPath
			) as? NewsCell
		else {
			return UITableViewCell()
		}
		let item = viewModel.newsFeedItems[indexPath.row]
		cell.setup(with: item)
		return cell
	}
}

// MARK: - ErrorViewDelegate

extension NewsFeedViewController: ErrorViewDelegate {

	func update() {
		viewModel.viewActions.events.send(.refreshDidTap)
	}
}

// MARK: - Private

private extension NewsFeedViewController {

	func bind() {
		viewModel.data.reloadDataPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self else { return }
				refreshControl.endRefreshing()
				loadView.isHidden = true
				loadView.stopAnimation()
				tableView.reloadData()
			}.store(in: &subscriptions)
		viewModel.data.loadingPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self else { return }
				loadView.isHidden = false
				loadView.startAnimation()
			}.store(in: &subscriptions)
		viewModel.data.errorPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self else { return }
				loadView.isHidden = true
				loadView.stopAnimation()
				errorView.isHidden = false
			}.store(in: &subscriptions)
	}

	func setup() {
		title = "Новости"
		view.addSubviews(tableView, loadView, errorView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])

		NSLayoutConstraint.activate([
			loadView.topAnchor.constraint(equalTo: view.topAnchor),
			loadView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			loadView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			loadView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])

		NSLayoutConstraint.activate([
			errorView.topAnchor.constraint(equalTo: view.topAnchor),
			errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])
	}

	@objc
	func refresh() {
		viewModel.viewActions.events.send(.refreshDidTap)
	}
}
