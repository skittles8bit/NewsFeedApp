//
//  SettingsViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Foundation

typealias SettingsViewModelProtocol =
SettingsViewModelInputOutput & SettingsViewModelActionsAndData

final class SettingsViewModel: SettingsViewModelProtocol {
	let input: SettingsViewModelInput = .init()
	let output: SettingsViewModelOutput = .init()
	let data: SettingsViewModelData = .init()
	private(set) lazy var viewActions = SettingsViewModelActions()
}
