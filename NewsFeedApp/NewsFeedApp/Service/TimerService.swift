//
//  Timer.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import Foundation

/// Протокол таймера
protocol TimerServiceProtocol {
	/// Запустить
	func start()
	/// Остановить
	func stop()
}

/// Таймер
final class TimerService {

	private var timer: Timer?
	private var interval: TimeInterval
	private var updateHandler: (() -> Void)

	/// Инициализатор
	///  - Parameters:
	///   - interval: Период обновления таймера
	///   - updateHandler: Хэндлер обновления таймера
	init(
		interval: TimeInterval,
		updateHandler: @escaping () -> Void
	) {
		self.interval = interval
		self.updateHandler = updateHandler
		start()
	}
}

// MARK: - NewsTimerProtocol

extension TimerService: TimerServiceProtocol {

	func start() {
		stop()
		timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
			self?.updateHandler()
		}
	}

	func stop() {
		timer?.invalidate()
		timer = nil
	}
}
