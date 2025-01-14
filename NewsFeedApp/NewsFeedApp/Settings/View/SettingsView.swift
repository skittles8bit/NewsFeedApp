//
//  SettingsView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 8.01.25.
//

import Combine
import SwiftUI

class SettingsViewViewModel: ObservableObject {

	struct Dependencies {
		let storageService: StorageService
	}

	@Published var isTimerEnabled: Bool = false {
		didSet {
			saveSettings()
		}
	}
	@Published var showDescription: Bool = true {
		didSet {
			saveSettings()
		}
	}
	@Published var updateInterval: Int = 30 {
		didSet {
			saveSettings()
		}
	}
	@Published var isPickerPresented: Bool = false
	@Published var showAlert = false
	@Published var cacheCleared = false

	private let storageService: StorageServiceProtocol

	init(storageService: StorageServiceProtocol) {
		self.storageService = storageService
		setSettings()
	}

	private func setSettings() {
		let settings = storageService.fetchSettings()
		isTimerEnabled = settings.timerIsEnabled
		updateInterval = settings.interval
		isPickerPresented = settings.timerIsEnabled
	}

	private func saveSettings() {
		storageService.saveSettings(
			settings: .init(
				interval: updateInterval,
				timerIsEnabled: isTimerEnabled,
				showDescriptionIsEnabled: showDescription,
				newsSourceIsEnabled: false
			)
		)
	}
}

struct SettingsView: View {

	@ObservedObject private var viewModel: SettingsViewViewModel

	var body: some View {
		ZStack {
			Form {
				Group {
					Section {
						Toggle("Обновлять новости по таймеру", isOn: $viewModel.isTimerEnabled)
							.onChange(of: viewModel.isTimerEnabled) { value in
								if value {
									withAnimation {
										viewModel.isPickerPresented = true
									}
								} else {
									withAnimation {
										viewModel.isPickerPresented = false
									}
								}
							}
						if viewModel.isPickerPresented {
							Picker("Интервал обновления", selection: $viewModel.updateInterval) {
								ForEach([10, 15, 30, 40], id: \.self) { interval in
									Text("\(interval) секунд")
								}
							}
							.pickerStyle(.wheel)
							.frame(height: 150)
						}
						// Текст внизу секции
						Text("Вы можете настроить автоматическое обновление новостей.\nУбедитесь, что у вас есть стабильное соединение с интернетом.")
							.font(.footnote) // Установка размера шрифта для текста
							.foregroundColor(.gray) // Установка цвета текста
							.padding(.top, 5) // Отступ сверху
							.padding(.bottom, 10) // Отступ снизу
					}
				}

				Section {
					Toggle("Показывать описание новости", isOn: $viewModel.showDescription)
				}

				Section {
					NavigationLink(destination: AddSourceView()) {
						Text("Добавить источник")
					}
				}

				Section {
					Button(action: {
						viewModel.showAlert = true // Показать алерт
					}) {
						Text("Очистить кеш")
							.foregroundColor(.red)
					}
					.alert(isPresented: $viewModel.showAlert) {
						Alert(
							title: Text("Подтверждение"),
							message: Text("Вы уверены, что хотите очистить кеш?"),
							primaryButton: .destructive(Text("Очистить")) {
								clearCache() // Функция очистки кеша
							},
							secondaryButton: .cancel(Text("Отмена"))
						)
					}
				}
				//					.alert(isPresented: $cacheCleared) {
				//						Alert(title: Text("Кеш очищен"))
				//					}
			}
		}
	}

	init(viewModel: SettingsViewViewModel) {
		self.viewModel = viewModel
	}

	private func clearCache() {
		// Логика очистки кеша
		// Например, можно добавить код для удаления данных кеша
		viewModel.cacheCleared = true // Установить флаг о том, что кеш очищен
	}
}

struct AddSourceView: View {
	var body: some View {
		Text("Экран добавления источника")
			.font(.largeTitle)
			.navigationTitle("Добавить источник")
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		let storage: StorageServiceProtocol = StorageService(settingsStorageService: SettingsStorageService())
		SettingsView(viewModel: .init(storageService: storage))
	}
}
