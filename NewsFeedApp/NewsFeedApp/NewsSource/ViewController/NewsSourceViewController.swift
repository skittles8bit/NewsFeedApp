//
//  NewsSourceViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

final class NewsSourceViewController: UIViewController {

	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: view.bounds, style: .plain)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .systemBackground
		tableView.separatorStyle = .singleLine
		return tableView
	}()

	private let viewModel: NewsSourceViewModelActionsAndData
	private var subscriptions = Subscriptions()

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.viewActions.lifecycle.send(.didLoad)
		setup()
		bind()
	}

	init(viewModel: NewsSourceViewModelActionsAndData) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UITableViewDataSource

extension NewsSourceViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.data.newsSources.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = viewModel.data.newsSources[indexPath.row]
		cell.selectionStyle = .none
		return cell
	}
}

// MARK: - UITableViewDelegate

extension NewsSourceViewController: UITableViewDelegate {

	func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		guard editingStyle == .delete else { return }
		viewModel.viewActions.events.send(.didTapDelete(indexPath.row))
		DispatchQueue.main.async {
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}

	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		let selectedSource = viewModel.data.newsSources[indexPath.row]
		presentSourceAlert(
			title: "Редактировать источник",
			message: "Измените название источника",
			sourceName: selectedSource
		) { [weak self] newSourceName in
			guard let self, let newSourceName else { return }
			viewModel.viewActions.events.send(
				.didTapSaveOrUpdateButton(
					indexPath.row,
					newSourceName
				)
			)
			DispatchQueue.main.async {
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		}
	}
}

// MARK: - Private

private extension NewsSourceViewController {

	func setup() {
		title = "Источники новостей"
		view.backgroundColor = .systemBackground

		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewsSource)
		)
	}

	func bind() {
		viewModel.data.updatePublisher
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: tableView.reloadData)
			.store(in: &subscriptions)
	}

	@objc func addNewsSource() {
		presentSourceAlert(
			title: "Добавить источник",
			message: "Введите название источника",
			sourceName: nil
		) { [weak self] sourceName in
			guard let self, let sourceName else { return }
			viewModel.viewActions.events.send(.didTapAddButton(sourceName))
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	func presentSourceAlert(
		title: String,
		message: String,
		sourceName: String?,
		completion: @escaping (String?) -> Void
	) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addTextField { textField in
			textField.placeholder = "Название источника"
			textField.text = sourceName
		}

		let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
			let textField = alert.textFields?.first
			completion(textField?.text?.isEmpty == false ? textField?.text : nil)
		}

		alert.addAction(saveAction)
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
			completion(nil)
		})

		present(alert, animated: true)
	}
}
