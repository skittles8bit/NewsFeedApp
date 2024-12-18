//
//  SettingsViewModelInputOutput.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

protocol SettingsViewModelInputOutput {
	var input: SettingsViewModelInput { get }
	var output: SettingsViewModelOutput { get }
}

struct SettingsViewModelInput {}
struct SettingsViewModelOutput {}
