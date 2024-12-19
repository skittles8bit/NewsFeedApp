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
		pickerView.backgroundColor = .systemBackground
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

// MARK: - UIPickerViewDataSource

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

	func pickerView(
		_ pickerView: UIPickerView,
		titleForRow row: Int,
		forComponent component: Int
	) -> String? {
		return "\(periods[row]) сек"
	}

	func pickerView(
		_ pickerView: UIPickerView,
		didSelectRow row: Int,
		inComponent component: Int
	) {
		delegate?.didSelectTimer(period: periods[row])
	}
}

// MARK: - Private

private extension TimerPickerView {

	enum Constants {
		static let pickerViewHeight: CGFloat = 150
		static let cornerRadius: CGFloat = 10
		static let borderWidth: CGFloat = 1
	}

	func setup() {
		pickerView.delegate = self
		pickerView.dataSource = self

		// Настройка внешнего вида
		pickerView.layer.cornerRadius = Constants.cornerRadius
		pickerView.layer.borderWidth = Constants.borderWidth
		pickerView.layer.borderColor = UIColor.systemBlue.cgColor
		pickerView.setValue(UIColor.systemBlue, forKey: "textColor")

		addSubview(pickerView)

		NSLayoutConstraint.activate([
			pickerView.topAnchor.constraint(equalTo: topAnchor),
			pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
			pickerView.heightAnchor.constraint(equalToConstant: Constants.pickerViewHeight)
		])
	}
}
