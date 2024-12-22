//
//  NewsSourceViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

final class NewsSourceViewController: UIViewController {

	var newsSources: [String] = []
	let tableView = UITableView()

	private let viewModel: NewsSourceViewModelActionsAndData

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

	init(viewModel: NewsSourceViewModelActionsAndData) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func addNewsSource() {
		presentSourceAlert(title: "Добавить источник", message: "Введите название источника", sourceName: nil) { sourceName in
			if let sourceName = sourceName {
				self.newsSources.append(sourceName)
				self.tableView.reloadData()
			}
		}
	}

	func presentSourceAlert(title: String, message: String, sourceName: String?, completion: @escaping (String?) -> Void) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addTextField { textField in
			textField.placeholder = "Название источника"
			textField.text = sourceName
		}

		let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
			let textField = alert.textFields![0]
			completion(textField.text?.isEmpty == false ? textField.text : nil)
		}

		alert.addAction(saveAction)
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
			completion(nil)
		})

		present(alert, animated: true)
	}
}

// MARK: - UITableViewDataSource

extension NewsSourceViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newsSources.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = newsSources[indexPath.row]
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
		if editingStyle == .delete {
			newsSources.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}

	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		let selectedSource = newsSources[indexPath.row]
		presentSourceAlert(
			title: "Редактировать источник",
			message: "Измените название источника",
			sourceName: selectedSource
		) { newSourceName in
			if let newSourceName = newSourceName {
				self.newsSources[indexPath.row] = newSourceName
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		}
	}
}

// MARK: - Private

private extension NewsSourceViewController {

	func setup() {
		title = "Источники новостей"
		view.backgroundColor = .white

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewsSource))
	}
}
