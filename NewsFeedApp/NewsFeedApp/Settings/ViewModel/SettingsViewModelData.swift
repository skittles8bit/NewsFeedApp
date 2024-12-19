//
//  SettingsViewModelData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

struct SettingsViewModelData {
	let switchStatePublisher: AnyPublisher<Bool, Never>
	let pickerViewStatePublisher: AnyPublisher<SettingsPickerViewStateModel, Never>
}
