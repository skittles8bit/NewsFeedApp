//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

final class NewsFeedViewController: UIViewController {

	private let viewModel: NewsFeedViewModelActionsAndData

	private lazy var tableView: TableView = {
		let tableView = TableView()
		tableView.delegate = self
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
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

	private lazy var settingsBarButtonItem: UIBarButtonItem = {
		let settingsBarButtonItem = UIBarButtonItem(
			image: Constants.settingsImage,
			style: .plain,
			target: self,
			action: #selector(settings)
		)
		settingsBarButtonItem.tintColor = .systemBlue
		return settingsBarButtonItem
	}()

	private var subscriptions = Subscriptions()

	init(with viewModel: NewsFeedViewModelActionsAndData) {
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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.viewActions.lifecycle.send(.willAppear)
	}
}

extension NewsFeedViewController: TableViewDelegate {

	func didUpdate() {
		viewModel.viewActions.events.send(.didUpdate)
	}
}

// MARK: - ErrorViewDelegate

extension NewsFeedViewController: ErrorViewDelegate {

	func update() {
		viewModel.viewActions.events.send(.didUpdate)
	}
}

// MARK: - Private

private extension NewsFeedViewController {

	enum Constants {
		static let navigationBarTitle: String = "Новости"
		static let settingsImage: UIImage? = UIImage(systemName: "gearshape")
	}

	func bind() {
		viewModel.data.reloadDataPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self else { return }
				loadView.isHidden = true
				loadView.stopAnimation()
				tableView.updateSnapshot(with: viewModel.data.newsFeedItems)
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
		title = Constants.navigationBarTitle
		view.addSubviews(tableView, loadView, errorView)
		setupRightBarButtonItem()
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
			errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])
	}

	func setupRightBarButtonItem() {
		navigationItem.rightBarButtonItem = settingsBarButtonItem
	}

	@objc
	func refresh() {
		viewModel.viewActions.events.send(.didUpdate)
	}

	@objc
	func settings() {
		viewModel.viewActions.events.send(.didTapSettings)
	}
}
