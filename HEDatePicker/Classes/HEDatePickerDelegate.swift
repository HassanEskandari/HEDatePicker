//
//  HEDatePickerDelegate.swift
//  HEDatePicker
//
//  Created by Hassan on 8/11/17.
//  Copyright © 2017 hassaneskandari. All rights reserved.
//


import Foundation

public protocol HEDatePickerDelegate {
    func pickerView(_ pickerView: HEDatePicker, didSelectRow row: Int, inComponent component: Int)
}
