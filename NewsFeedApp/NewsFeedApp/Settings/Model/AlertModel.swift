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
	}

	/// Состояния экшена
	enum ActionState {
		/// Очистить
		case clear
		/// Отмена
		case cancel
	}

	/// Заголовок
	let title: String?
	/// Описание
	let message: String
	/// Действия
	let actions: [UIAlertAction]
}

extension AlertModel {

	/// Инициализатор
	///  - Parameters:
	///   - state: Состояние
	///   - action: Экшн по нажатию кнопки
	init(with state: State, action: ((ActionState) -> Void)? = nil ) {
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
		case .done:
			title = nil
			message = "Очистка кэша произведена"
			actions = [
				UIAlertAction(title: "Закрыть", style: .destructive) { _ in
					action?(.cancel)
				}
			]
		}
	}
}
