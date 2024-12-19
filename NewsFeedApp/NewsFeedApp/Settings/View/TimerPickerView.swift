//
//  TimerPickerView.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import UIKit

protocol TimerPickerViewDelegate: AnyObject {
	func didSelectTimer(period: Int)
}

final class TimerPickerView: UIView {

	private let periods = [10, 15, 20, 25, 30]

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

	func configure(with period: Int){
		pickerView.selectRow(
			periods.firstIndex(of: period) ?? .zero,
			inComponent: .zero,
			animated: false
		)
	}
}

extension TimerPickerView: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		periods.count
	}
}

// MARK: - UIPickerViewDelegate

extension TimerPickerView: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "\(periods[row]) сек"
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		delegate?.didSelectTimer(period: periods[row])
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
