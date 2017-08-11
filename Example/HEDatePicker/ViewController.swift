//
//  ViewController.swift
//  HEDatePicker
//
//  Created by hassan.3skandari@gmail.com on 08/11/2017.
//  Copyright (c) 2017 hassan.3skandari@gmail.com. All rights reserved.
//

import UIKit
import HEDatePicker

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: HEDatePicker!
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.delegate = self
        self.datePicker.identifier = .persian
        self.datePicker.locale = Locale(identifier: "fa_IR")
        self.datePicker.pickerType = .date
//        self.datePicker.font = IranYekanFont.regular(with: 14)
        self.datePicker.reloadAllComponents()
        
//        self.label.font = IranYekanFont.regular(with: 20)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: HEDatePickerDelegate {
    func pickerView(_ pickerView: HEDatePicker, didSelectRow row: Int, inComponent component: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa_IR")
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        self.label.text = dateFormatter.string(from: pickerView.date)
    }
}
