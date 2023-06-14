//
//  UITimePicker.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol TimePickerDelegate: AnyObject {
    func timePicker(picker: UITimePicker, didSelectedTime time: (hour: Int, minute: Int))
}

class UITimePicker: UIPickerView {
    private var amValue = "오전"
    private var hourCollection = Array(0...12)
    private var minuteCollection = Array(stride(from: 0, through: 50, by: 10))
    
    weak var timeDelegate: TimePickerDelegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIConstants.Colors.secondaryColor
        layer.cornerRadius = 8
        delegate = self
        dataSource = self
        // TODO: - 설정된 시간 설정
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UITimePicker: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        widthForComponent component: Int
    ) -> CGFloat {
        return 100
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        let hourRow = pickerView.selectedRow(inComponent: 1)
        let minuteRow = pickerView.selectedRow(inComponent: 2)
        
        let hour = hourCollection[hourRow]
        let minute = minuteCollection[minuteRow]
        timeDelegate?.timePicker(picker: self, didSelectedTime: (hour, minute))
    }
}

extension UITimePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        if component == .zero {
            return 1
        } else if component == 1 {
            return hourCollection.count
        } else {
            return minuteCollection.count
        }
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        
        if component == .zero {
            label.text = amValue
        } else if component == 1 {
            let item = hourCollection[row].dateDescription + " " + "시"
            label.text = item
        } else {
            let item = minuteCollection[row].dateDescription + " " + "분"
            label.text = item
        }
        
        return label
    }
}
