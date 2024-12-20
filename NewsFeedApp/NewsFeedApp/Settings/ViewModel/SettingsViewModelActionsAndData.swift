//
//  SettingsViewModelActionsAndData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Foundation

/// Протокол данных и экшенов вьюмодели
protocol SettingsViewModelActionsAndData {
	/// Данные вьюмодели
	var data: SettingsViewModelData { get }
	/// Экшены вью
	var viewActions: SettingsViewModelActions { get }
}
