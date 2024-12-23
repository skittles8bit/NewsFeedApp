//
//  AlertModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

/// Модель модального вью
struct AlertModel {

	/// Состояния
	enum State {
		/// Подтверждение
		case conformation
		/// Завершение
		case done
		/// Редактирование
		case editing(String)
		/// Добавление
		case adding
	}

	/// Состояния экшена
	enum ActionState {
		/// Очистить
		case clear
		/// Отмена
		case cancel
		/// Добавить или сохранить
		case addOrSave
	}

	/// Заголовок
	let title: String?
	/// Описание
	let message: String
	/// Поле ввода
	let textField: UITextField?
	/// Действия
	let actions: [UIAlertAction]
}

extension AlertModel {

	/// Инициализатор
	///  - Parameters:
	///   - state: Состояние
	///   - action: Экшн по нажатию кнопки
	init(with state: State, action: ((ActionState) -> Void)? = nil) {
		switch state {
		case .conformation:
			title = "Очистка кэша"
			message = "Вы уверены, что хотите очистить кэш?"
			actions = [
				UIAlertAction(title: "Очистить", style: .destructive) { _ in
					action?(.clear)
				},
				UIAlertAction(title: "Отменить", style: .cancel) { _ in
					action?(.cancel)
				}
			]
			self.textField = nil
		case .done:
			title = nil
			message = "Очистка кэша произведена"
			actions = [
				UIAlertAction(title: "Закрыть", style: .destructive) { _ in
					action?(.cancel)
				}
			]
			textField = nil
		case let .editing(text):
			title = "Редактировать источник"
			message = "Измените название источника"
			textField = UITextField()
			textField?.placeholder = "Название источника"
			textField?.text = text
			actions = [
				UIAlertAction(title: "Сохранить", style: .default) { _ in
					action?(.addOrSave)
				},
				UIAlertAction(title: "Отмена", style: .cancel) { _ in
					action?(.cancel)
				}
			]
		case .adding:
			title = "Добавить источник"
			message = "Введите название источника"
			textField = UITextField()
			textField?.placeholder = "Название источника"
			actions = [
				UIAlertAction(title: "Сохранить", style: .default) { _ in
					action?(.addOrSave)
				},
				UIAlertAction(title: "Отмена", style: .cancel) { _ in
					action?(.cancel)
				}
			]
		}
	}
}
