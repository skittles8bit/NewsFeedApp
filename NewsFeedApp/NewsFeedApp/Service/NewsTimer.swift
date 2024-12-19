//
//  Timer.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import Foundation

protocol NewsTimerProtocol {
	func start()
	func stop()
}

final class NewsTimer {

	private var timer: Timer?
	private var interval: TimeInterval
	private var updateHandler: (() -> Void)

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

extension NewsTimer: NewsTimerProtocol {

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
