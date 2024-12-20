//
//  AlertModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

struct AlertModel {

	enum State {
		case conformation
		case done
	}

	enum ActionState {
		case clear
		case cancel
	}

	let title: String?
	let message: String
	let actions: [UIAlertAction]
}

extension AlertModel {

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
