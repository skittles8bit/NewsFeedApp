//
//  SettingsViewModelActionsAndData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Foundation

protocol SettingsViewModelActionsAndData {
	var data: SettingsViewModelData { get }
	var viewActions: SettingsViewModelActions { get }
}
