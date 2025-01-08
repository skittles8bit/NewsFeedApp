//
//  SettingsView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 8.01.25.
//

import SwiftUI

struct SettingsView: View {
	@State private var isTimerEnabled: Bool = false
	@State private var showDescription: Bool = true
	@State private var updateInterval: Int = 30 // Время обновления в секундах
	@State private var isPickerPresented: Bool = false
	@State private var showAlert = false
	@State private var cacheCleared = false

	var body: some View {
		ZStack {
			Form {
				Section {
					Toggle("Обновлять новости по таймеру", isOn: $isTimerEnabled)
						.onChange(of: isTimerEnabled) { value in
							if value {
								withAnimation {
									isPickerPresented = true
								}
							} else {
								withAnimation {
									isPickerPresented = false
								}
							}
						}
					// Текст внизу секции
					Text("Вы можете настроить автоматическое обновление новостей.\nУбедитесь, что у вас есть стабильное соединение с интернетом.")
						.font(.footnote) // Установка размера шрифта для текста
						.foregroundColor(.gray) // Установка цвета текста
						.padding(.top, 5) // Отступ сверху
						.padding(.bottom, 10) // Отступ снизу
				}

				Section {
					Toggle("Показывать описание новости", isOn: $showDescription)
				}

				Section {
					NavigationLink(destination: AddSourceView()) {
						Text("Добавить источник")
					}
				}

				Section {
					Button(action: {
						showAlert = true // Показать алерт
					}) {
						Text("Очистить кеш")
							.foregroundColor(.red)
					}
					.alert(isPresented: $showAlert) {
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

			if isPickerPresented {
				BottomPickerView(
					updateInterval: $updateInterval,
					isPresented: $isPickerPresented
				)
				.transition(
					.opacity.animation(.easeInOut)
				)
			}
		}
	}


	private func clearCache() {
		// Логика очистки кеша
		// Например, можно добавить код для удаления данных кеша
		cacheCleared = true // Установить флаг о том, что кеш очищен
	}
}

struct BottomPickerView: View {

	@Binding var updateInterval: Int
	@Binding var isPresented: Bool

	var body: some View {
		VStack(spacing: 20) {
			Text("Выберите интервал обновления")
				.font(.headline)

			Picker("Интервал обновления", selection: $updateInterval) {
				ForEach([10, 15, 30, 40], id: \.self) { interval in
					Text("\(interval) секунд")
				}
			}
			.pickerStyle(.wheel)

			Button("Готово") {
				withAnimation {
					isPresented = false
				}
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.cornerRadius(10)
		}
		.padding()
		.background(Color.white)
		.cornerRadius(12)
		.shadow(radius: 10)
		.padding()
		.transition(.scale.animation(.easeInOut(duration: TimeInterval(0.3))))
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
		SettingsView()
	}
}
