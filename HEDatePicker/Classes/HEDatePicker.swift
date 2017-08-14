//
//  HEDatePicker.swift
//  HEDatePicker
//
//  Created by Hassan on 8/11/17.
//  Copyright © 2017 hassaneskandari. All rights reserved.
//


import UIKit
import Foundation

public class HEDatePicker: UIControl {
    
    // MARK: - Public Properties
    public var delegate: HEDatePickerDelegate?
    /// The font for the date picker.
    public var font = UIFont.systemFont(ofSize: 15.0)
    /// The text color for the date picker components.
    public var textColor = UIColor.black
    /// The minimum date to show for the date picker. Set to NSDate.distantPast() by default
    public var minimumDate = Date.distantPast {
        didSet {
            self.validateMinimumAndMaximumDate()
        }
    }
    /// The maximum date to show for the date picker. Set to NSDate.distantFuture() by default
    public var maximumDate = Date.distantFuture {
        didSet {
            self.validateMinimumAndMaximumDate()
        }
    }
    /// The current locale to use for formatting the date picker. By default, set to the device's current locale
    public var locale : Locale = Locale.current {
        didSet {
            self.calendar.locale = self.locale
        }
    }
    public var identifier: Calendar.Identifier = .gregorian {
        didSet {
            self.calendar = Calendar(identifier: identifier)
            self.updatePickerViewComponentValuesAnimated(false)
        }
    }
    /// The current date value of the date picker.
    public fileprivate(set) var date = Date()

    public var pickerType: HEDatePickerType = .dateTime
    public var customPickerType = ""
    
    // MARK: - Private Variables
    fileprivate let numberofYears = 200
    /// The internal picker view used for laying out the date components.
    fileprivate let pickerView = UIPickerView()
    /// The calendar used for formatting dates.
    fileprivate var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    /// Calculates the current calendar components for the current date.
    fileprivate var currentCalendarComponents : DateComponents {
        get {
            return (self.calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: self.date)
        }
    }
    /// Gets the text color to be used for the label in a disabled state
    fileprivate var disabledTextColor : UIColor {
        get {
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            
            self.textColor.getRed(&r, green: &g, blue: &b, alpha: nil)
            
            return UIColor(red: r, green: g, blue: b, alpha: 0.35)
        }
    }
    /// The order in which each component should be ordered in.
    fileprivate var datePickerComponentOrdering = [HEDatePickerComponents]()
    
    // MARK: - LifeCycle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    /**
    Handles the common initialization amongst all init()
    */
    func commonInit() {     
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.addSubview(self.pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.pickerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.pickerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.pickerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.pickerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    // MARK: - Override
    public override var intrinsicContentSize : CGSize {
        return self.pickerView.intrinsicContentSize
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.reloadAllComponents()
        
        self.setDate(self.date)
    }
    
    // MARK: - Public
    
    /**
     Reloads all of the components in the date picker.
     */
    public func reloadAllComponents() {
        self.datePickerComponentOrdering = [HEDatePickerComponents]()
        self.refreshComponentOrdering()
        self.pickerView.reloadAllComponents()
    }
    
    /**
     Sets the current date value for the date picker.
     
     :param: date     The date to set the picker to.
     :param: animated True if the date picker should changed with an animation; otherwise false,
     */
    public func setDate(_ date : Date, animated : Bool) {
        self.date = date
        self.updatePickerViewComponentValuesAnimated(animated)
    }
    
    // MARK: - Private
    
    /**
     Sets the current date with no animation.
     
     :param: date The date to be set.
     */
    fileprivate func setDate(_ date : Date) {
        self.setDate(date, animated: false)
    }
    
    /**
     Creates a new date formatter with the locale and calendar
     
     :returns: A new instance of NSDateFormatter
     */
    fileprivate func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = self.calendar
        dateFormatter.locale = self.locale
        
        return dateFormatter
    }
    
    /**
     Refreshes the ordering of components based on the current locale. Calling this function will not refresh the picker view.
     */
    fileprivate func refreshComponentOrdering() {

        var format = self.pickerType.rawValue
        if self.pickerType == .custom {
            format = self.customPickerType
        }
        
        format.characters.forEach { (component) in
            if let pickerComponent = HEDatePickerComponents(rawValue: component) {
                self.datePickerComponentOrdering.append(pickerComponent)
            }
        }
    }
    
    /**
     Validates that the set minimum and maximum dates are valid.
     */
    fileprivate func validateMinimumAndMaximumDate() {
        let ordering = self.minimumDate.compare(self.maximumDate)
        if (ordering != .orderedAscending ){
            fatalError("Cannot set a maximum date that is equal or less than the minimum date.")
        }
    }
    
    /**
     Gets the value of the current component at the specified row.
     
     :param: row            The row index whose value is required
     :param: componentIndex The component index for the row.
     
     :returns: A string containing the value of the current row at the component index.
     */
    fileprivate func titleForRow(_ row : Int, inComponentIndex componentIndex: Int) -> String {
        let dateComponent = self.componentAtIndex(componentIndex)
        
        let value = self.rawValueForRow(row, inComponent: dateComponent)
        
        if dateComponent == HEDatePickerComponents.month {
            let dateFormatter = self.dateFormatter()
            return dateFormatter.monthSymbols[value - 1]
        } else if dateComponent == .hour || dateComponent == .minute {
            return String(format: "%02d", value)
        } else {
            return String(value)
        }
    }
    
    /**
     Gets the value of the input component using the current date.
     
     :param: component The component whose value is needed.
     
     :returns: The value of the component.
     */
    fileprivate func valueForDateComponent(_ component : HEDatePickerComponents) -> Int{
        if component == .year {
            return self.currentCalendarComponents.year!
        } else if component == .day {
            return self.currentCalendarComponents.day!
        } else if component == .month {
            return self.currentCalendarComponents.month!
        } else if component == .hour {
            return self.currentCalendarComponents.hour!
        } else if component == .minute {
            return self.currentCalendarComponents.minute!
        }
        
        return -1
    }
    
    /**
     Gets the maximum range for the specified date picker component.
     
     :param: component The component to get the range for.
     
     :returns: The maximum date range for that component.
     */
    fileprivate func maximumRangeForComponent(_ component : HEDatePickerComponents) -> Range<Int> {
        var calendarUnit : Calendar.Component
        if component == .year {
            var currentYear = self.date.year()
            if self.calendar.identifier == .persian {
                currentYear = self.date.jalaali().year
            }
            
            return Range(uncheckedBounds: (lower: currentYear - numberofYears / 2, upper: currentYear + numberofYears / 2))
            
        } else if component == .day {
//            var currentMonth = self.date.month()
//            var currentYear = self.date.year()
//            if self.calendar.identifier == .persian {
//                currentMonth = self.date.jalaali().month
//                currentYear = self.date.jalaali().year
//            }
//            return Range(uncheckedBounds: (lower: 1, upper: self.numberOfDaysForMonth(currentMonth, inYear: currentYear) + 1))
            calendarUnit = .day
        } else if component == .month {
            calendarUnit = .month
        } else if component == .hour {
            calendarUnit = .hour
        } else if component == .minute {
            calendarUnit = .minute
        } else {
            return Range(uncheckedBounds: (lower: 0, upper: 0))
        }
        
        
        return self.calendar.maximumRange(of: calendarUnit)!
    }
    
    /**
     Calculates the raw value of the row at the current index.
     
     :param: row       The row to get.
     :param: component The component which the row belongs to.
     
     :returns: The raw value of the row, in integer. Use NSDateComponents to convert to a usable date object.
     */
    fileprivate func rawValueForRow(_ row : Int, inComponent component : HEDatePickerComponents) -> Int {
        if component == .space {
            return -1
        }
        
        let calendarUnitRange = self.maximumRangeForComponent(component)
        return calendarUnitRange.lowerBound + (row % (calendarUnitRange.upperBound - calendarUnitRange.lowerBound))
    }
    
    /**
     Checks if the specified row should be enabled or not.
     
     :param: row       The row to check.
     :param: component The component to check the row in.
     
     :returns: YES if the row should be enabled; otherwise NO.
     */
    fileprivate func isRowEnabled(_ row: Int, forComponent component : HEDatePickerComponents) -> Bool {
        
        let rawValue = self.rawValueForRow(row, inComponent: component)
        
        var components = DateComponents()
        components.year = self.currentCalendarComponents.year
        components.month = self.currentCalendarComponents.month
        components.day = self.currentCalendarComponents.day
        components.hour = self.currentCalendarComponents.hour
        components.minute = self.currentCalendarComponents.minute
        
        if component == .year {
            components.year = rawValue
        } else if component == .day {
            components.day = rawValue
        } else if component == .month {
            components.month = rawValue
        } else if component == .hour {
            components.hour = rawValue
        } else if component == .minute {
            components.minute = rawValue
        }
        
        let dateForRow = self.calendar.date(from: components)!
        
        return self.dateIsInRange(dateForRow)
    }
    
    /**
     Checks if the input date falls within the date picker's minimum and maximum date ranges.
     
     :param: date The date to be checked.
     
     :returns: True if the input date is within range of the minimum and maximum; otherwise false.
     */
    fileprivate func dateIsInRange(_ date : Date) -> Bool {
        return self.minimumDate.compare(date) != ComparisonResult.orderedDescending &&
            self.maximumDate.compare(date) != ComparisonResult.orderedAscending
    }
    
    /**
     Updates all of the date picker components to the value of the current date.
     
     :param: animated True if the update should be animated; otherwise false.
     */
    fileprivate func updatePickerViewComponentValuesAnimated(_ animated : Bool) {
        for (_, dateComponent) in self.datePickerComponentOrdering.enumerated() {
            self.setIndexOfComponent(dateComponent, animated: animated)
        }
    }
    
    /**
     Updates the index of the specified component to its relevant value in the current date.
     
     :param: component The component to be updated.
     :param: animated  True if the update should be animated; otherwise false.
     */
    fileprivate func setIndexOfComponent(_ component : HEDatePickerComponents, animated: Bool) {
        self.setIndexOfComponent(component, toValue: self.valueForDateComponent(component), animated: animated)
    }
    
    /**
     Updates the index of the specified component to the input value.
     
     :param: component The component to be updated.
     :param: value     The value the component should be updated ot.
     :param: animated  True if the update should be animated; otherwise false.
     */
    fileprivate func setIndexOfComponent(_ component : HEDatePickerComponents, toValue value : Int, animated: Bool) {
        
        if component == .space {
            return
        }
        
        let componentRange = self.maximumRangeForComponent(component)
        
        let idx = (value - componentRange.lowerBound)
        let middleIndex = /*(self.maximumNumberOfRows / 2) - (maximumNumberOfRows / 2) % (componentRange.upperBound - componentRange.lowerBound) +*/ idx
        
        var componentIndex = 0
        
        for (index, dateComponent) in self.datePickerComponentOrdering.enumerated() {
            if (dateComponent == component) {
                componentIndex = index
            }
        }
        
        self.pickerView.selectRow(middleIndex, inComponent: componentIndex, animated: animated)
    }
    
    /**
     Gets the component type at the current component index.
     
     :param: index The component index
     
     :returns: The date picker component type at the index.
     */
    fileprivate func componentAtIndex(_ index: Int) -> HEDatePickerComponents {
        if self.datePickerComponentOrdering.count > index {
            return self.datePickerComponentOrdering[index]
        } else {
            return HEDatePickerComponents.invalid
        }
    }
    
    /**
     Gets the number of days of the specified month in the specified year.
     
     :param: month The month whose maximum date value is requested.
     :param: year  The year for which the maximum date value is required.
     
     :returns: The number of days in the month.
     */
    fileprivate func numberOfDaysForMonth(_ month : Int, inYear year : Int) -> Int {
        var components = DateComponents()
        components.month = month
        components.day = 1
        components.year = year
        
        let calendarRange = (self.calendar as NSCalendar).range(of: .day, in: .month, for: self.calendar.date(from: components)!)
        let numberOfDaysInMonth = calendarRange.length
        
        return numberOfDaysInMonth
    }
    
    /**
     Determines if updating the specified component to the input value would evaluate to a valid date using the current date values.
     
     :param: value     The value to be updated to.
     :param: component The component whose value should be updated.
     
     :returns: True if updating the component to the specified value would result in a valid date; otherwise false.
     */
    fileprivate func isValidValue(_ value : Int, forComponent component: HEDatePickerComponents) -> Bool {
        if (component == .year) {
            let numberOfDaysInMonth = self.numberOfDaysForMonth(self.currentCalendarComponents.month!, inYear: value)
            return self.currentCalendarComponents.day! <= numberOfDaysInMonth
        } else if (component == .day) {
            let numberOfDaysInMonth = self.numberOfDaysForMonth(self.currentCalendarComponents.month!, inYear: self.currentCalendarComponents.year!)
            return value <= numberOfDaysInMonth
        } else if (component == .month) {
            let numberOfDaysInMonth = self.numberOfDaysForMonth(value, inYear: self.currentCalendarComponents.year!)
            return self.currentCalendarComponents.day! <= numberOfDaysInMonth
        }
        
        return true
    }
    
    /**
     Creates date components by updating the specified component to the input value. This does not do any date validation.
     
     :param: component The component to be updated.
     :param: value     The value the component should be updated to.
     
     :returns: The components by updating the current date's components to the specified value.
     */
    fileprivate func currentCalendarComponentsByUpdatingComponent(_ component : HEDatePickerComponents, toValue value : Int) -> DateComponents {
        var components = self.currentCalendarComponents
        
        if (component == .month) {
            components.month = value
        } else if (component == .day) {
            components.day = value
        } else if (component == .year) {
            components.year = value
        } else if (component == .hour) {
            components.hour = value
        } else if (component == .minute) {
            components.minute = value
        }
        
        return components
    }
    
    /**
     Creates date components by updating the specified component to the input value. If the resulting value is not a valid date object, the components will be updated to the closest best value.
     
     :param: component The component to be updated.
     :param: value     The value the component should be updated to.
     
     :returns: The components by updating the specified value; the components will be a valid date object.
     */
    fileprivate func validDateValueByUpdatingComponent(_ component : HEDatePickerComponents, toValue value : Int) -> DateComponents {
        var components = self.currentCalendarComponentsByUpdatingComponent(component, toValue: value)
        if (!self.isValidValue(value, forComponent: component)) {
            if (component == .month) {
                components.day = self.numberOfDaysForMonth(value, inYear: components.year!)
            } else if (component == .day) {
                components.day = self.numberOfDaysForMonth(components.month!, inYear:components.year!)
            } else {
                components.day = self.numberOfDaysForMonth(components.month!, inYear: value)
            }
        }
        
        return components
    }
}

// MARK: - Protocols
// MARK: UIPickerViewDelegate
extension HEDatePicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let datePickerComponent = self.componentAtIndex(component)
        let value = self.rawValueForRow(row, inComponent: datePickerComponent)
        
        // Create the newest valid date components.
        let components = self.validDateValueByUpdatingComponent(datePickerComponent, toValue: value)
        
        // If the resulting components are not in the date range ...
        if (!self.dateIsInRange(self.calendar.date(from: components)!)) {
            // ... go back to original date
            self.setDate(self.date, animated: true)
        } else {
            // Get the components that would result by just force-updating the current components.
            let rawComponents = self.currentCalendarComponentsByUpdatingComponent(datePickerComponent, toValue: value)
            
            let day = components.day!
            
            if (rawComponents.day != components.day) {
                // Only animate the change if the day value is not a valid date.
                self.setIndexOfComponent(.day, toValue: day, animated: self.isValidValue(day, forComponent: .day))
            }
            
            if (rawComponents.month != components.month) {
                self.setIndexOfComponent(.month, toValue: day, animated: datePickerComponent != .month)
            }
            
            if (rawComponents.year != components.year) {
                self.setIndexOfComponent(.year, toValue: day, animated: datePickerComponent != .year)
            }
            
            self.date = self.calendar.date(from: components)!
            self.sendActions(for: .valueChanged)
        }
        
        self.delegate?.pickerView(self, didSelectRow: row, inComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel == nil ? UILabel() : view as! UILabel
        
        label.font = self.font
        label.textColor = self.textColor
        if self.calendar.identifier == .persian {
            label.text = self.titleForRow(row, inComponentIndex: component).changeNumbers()
            label.textAlignment = self.componentAtIndex(component) == .month ? .center : NSTextAlignment.center
        } else {
            label.text = self.titleForRow(row, inComponentIndex: component)
            label.textAlignment = self.componentAtIndex(component) == .month ? NSTextAlignment.left : NSTextAlignment.right
        }
        label.textColor = self.isRowEnabled(row, forComponent: self.componentAtIndex(component)) ? self.textColor : self.disabledTextColor
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let widthBuffer = 25.0
        
        let calendarComponent = self.componentAtIndex(component)
        let stringSizingAttributes = [NSFontAttributeName : self.font]
        var size = 0.01
        
        if calendarComponent == .month {
            let dateFormatter = self.dateFormatter()
            
            // Get the length of the longest month string and set the size to it.
            for symbol in dateFormatter.monthSymbols as [String] {
                let monthSize = NSString(string: symbol).size(attributes: stringSizingAttributes)
                size = max(size, Double(monthSize.width))
            }
        } else if calendarComponent == .day{
            // Pad the day string to two digits
            let dayComponentSizingString = NSString(string: "00")
            size = Double(dayComponentSizingString.size(attributes: stringSizingAttributes).width)
        } else if calendarComponent == .year  {
            // Pad the year string to four digits.
            let yearComponentSizingString = NSString(string: "00")
            size = Double(yearComponentSizingString.size(attributes: stringSizingAttributes).width)
        } else if calendarComponent == .hour  {
            // Pad the year string to four digits.
            let yearComponentSizingString = NSString(string: "00")
            size = Double(yearComponentSizingString.size(attributes: stringSizingAttributes).width)
        } else if calendarComponent == .minute  {
            // Pad the year string to four digits.
            let yearComponentSizingString = NSString(string: "00")
            size = Double(yearComponentSizingString.size(attributes: stringSizingAttributes).width)
        } else if (calendarComponent == .space) {
            size = 20.0
        }
        
        // Add the width buffer in order to allow the picker components not to run up against the edges
        return CGFloat(size + widthBuffer)
    }
    
}

// MARK: UIPickerViewDataSource
extension HEDatePicker: UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.componentAtIndex(component) {
        case .month:
            return 12
        case .day:
            return 31
        case .year:
            return 200
        case .hour:
            return 24
        case .minute:
            return 60
        default:
            return 0
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.pickerType == .custom {
            return self.customPickerType.characters.count
        } else {
            return self.pickerType.rawValue.characters.count
        }
    }
}


