//
//  SettingsViewController.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

final class SettingsViewController: UIViewController {

	private let viewModel: SettingsViewModelActionsAndData

	init(viewModel: SettingsViewModelActionsAndData) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
