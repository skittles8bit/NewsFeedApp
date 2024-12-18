//
//  TimerPickerView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import UIKit

protocol TimerPickerViewDelegate: AnyObject {
	func didSelectTimer(model: TimeIntervalModel)
}

final class TimerPickerView: UIView {

	// Массивы для выбора часов и минут
	private let hours = Array(0...23) // Часы от 0 до 23
	private let minutes = Array(0...59) // Минуты от 0 до 59
	private let seconds = Array(1...59) // Минуты от 0 до 59

	private var selectedHour = 0
	private var selectedMinute = 0
	private var selectedSecond = 1

	private lazy var pickerView: UIPickerView = {
		let pickerView = UIPickerView()
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		return pickerView
	}()

	weak var delegate: TimerPickerViewDelegate?

	init() {
		super.init(frame: .zero)

		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension TimerPickerView: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		3
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case .zero:
			hours.count
		case 1:
			minutes.count
		case 2:
			seconds.count
		default:
			.zero
		}
	}
}

// MARK: - UIPickerViewDelegate

extension TimerPickerView: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch component {
		case .zero:
			return "\(hours[row]) ч"
		case 1:
			return "\(minutes[row]) мин"
		case 2:
			return "\(seconds[row]) сек"
		default:
			return nil
		}
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch component {
		case .zero:
			selectedHour = hours[row]
		case 1:
			selectedMinute = minutes[row]
		case 2:
			selectedSecond = seconds[row]
		default:
			return
		}
		delegate?.didSelectTimer(
			model: .init(
				hour: selectedHour,
				minute: selectedMinute,
				second: selectedSecond
			)
		)
	}
}

private extension TimerPickerView {

	func setup() {
		pickerView.delegate = self
		pickerView.dataSource = self

		// Настройка внешнего вида
		pickerView.backgroundColor = .white
		pickerView.layer.cornerRadius = 10
		pickerView.layer.borderWidth = 1
		pickerView.layer.borderColor = UIColor.lightGray.cgColor

		addSubview(pickerView)

		NSLayoutConstraint.activate([
			pickerView.topAnchor.constraint(equalTo: topAnchor),
			pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
