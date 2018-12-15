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
    @IBOutlet weak var toggleLocaleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.delegate = self
        self.datePicker.identifier = .persian
        self.datePicker.locale = Locale(identifier: "fa_IR")
        self.datePicker.pickerType = .date
        self.datePicker.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func randomFont(_ sender: UIButton) {
        let familyNames = UIFont.familyNames
        let randomNumber = Int(arc4random_uniform(UInt32(familyNames.count)))
        let familyName = familyNames[randomNumber]
        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        if fontNames.count > 0 {
          let fontName = fontNames[0]
          self.datePicker.font = UIFont(name: fontName, size: 14)!
          self.datePicker.reloadAllComponents()
        }
    }
    @IBAction func randomColor(_ sender: UIButton) {
        let red = CGFloat(arc4random_uniform(255))
        let green = CGFloat(arc4random_uniform(255))
        let blue = CGFloat(arc4random_uniform(255))
        
        self.datePicker.textColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        self.datePicker.reloadAllComponents()
    }
    @IBAction func yearStyle(_ sender: UIButton) {
        self.datePicker.pickerType = .year
        self.datePicker.reloadAllComponents()
        self.datePicker.setDate(Date(), animated: false)
    }
    @IBAction func yearMonthStyle(_ sender: UIButton) {
        self.datePicker.pickerType = .yearMonth
        self.datePicker.reloadAllComponents()
        self.datePicker.setDate(Date(), animated: false)
    }
    @IBAction func dateStyle(_ sender: UIButton) {
        self.datePicker.pickerType = .date
        self.datePicker.reloadAllComponents()
        self.datePicker.setDate(Date(), animated: false)
    }
    @IBAction func dateTimeStyle(_ sender: UIButton) {
        self.datePicker.pickerType = .dateTime
        self.datePicker.reloadAllComponents()
        self.datePicker.setDate(Date(), animated: false)
    }
    @IBAction func customStyle(_ sender: UIButton) {
        self.datePicker.customPickerType = "hm"
        self.datePicker.pickerType = .custom
        self.datePicker.reloadAllComponents()
        self.datePicker.setDate(Date(), animated: false)
    }
    @IBAction func toggleLocale(_ sender: UIButton) {
        if self.datePicker.identifier == .persian {
            self.datePicker.identifier = .gregorian
            self.datePicker.locale = Locale(identifier: "en_US")
        } else {
            self.datePicker.identifier = .persian
            self.datePicker.locale = Locale(identifier: "fa_IR")
        }
        self.datePicker.reloadAllComponents()
        self.datePicker.setDate(Date(), animated: false)
    }
}

extension ViewController: HEDatePickerDelegate {
    func pickerView(_ pickerView: HEDatePicker, didSelectRow row: Int, inComponent component: Int) {
    }
}
