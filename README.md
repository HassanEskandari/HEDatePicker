![logo](https://user-images.githubusercontent.com/17081655/29253088-0e39c158-808a-11e7-8430-7a5fdcf184d9.png)
<br/><br/>
# HEDatePicker

[![CI Status](http://img.shields.io/travis/HassanEskandari/HEDatePicker.svg?style=flat)](https://travis-ci.org/HassanEskandari/HEDatePicker)
[![Version](https://img.shields.io/cocoapods/v/HEDatePicker.svg?style=flat)](http://cocoapods.org/pods/HEDatePicker)
[![License](https://img.shields.io/cocoapods/l/HEDatePicker.svg?style=flat)](http://cocoapods.org/pods/HEDatePicker)
[![Platform](https://img.shields.io/cocoapods/p/HEDatePicker.svg?style=flat)](http://cocoapods.org/pods/HEDatePicker)
[![Languages](https://img.shields.io/badge/Language-Swift%203.0-orange.svg)](https://img.shields.io/badge/Language-Swift%203.0-orange.svg)

## Description
A custom UIDatePicker object that allows design customization of various user interface attributes such as font, color, etc. This pod
aims to replicate the default UIDatePicker functionality while adding additional customization in the user interface.

This is project is inspired by and uses codes from [PIDatePicker](https://github.com/prolificinteractive/PIDatePicker).

In addition it has the option to set picker type to one of .year, .yearMonth, .date, .dateTime.
It is also possible to change calendar identifier.

## Example
![HEDatePicker](https://user-images.githubusercontent.com/17081655/29281251-8097edc0-8133-11e7-86e0-2aad993081f3.gif){:height="550px" width="310px"}

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

HEDatePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HEDatePicker"
```

Because this project was written in Swift, your project must have a minimum target of iOS 8.0 or greater. Cocoapods
does not support Swift pods for previous iOS versions. If you need to use this on a previous version of iOS, 
import the code files directly into your project or by using git submodules.

## Customization

There are several options available for customizing your date picker:

| Property              | Type      | Description                                                                                                       |
|:----------------------|:----------|:------------------------------------------------------------------------------------------------------------------|
| font			        | UIFont    | Sets the font that the date picker will use to display the dates. By default, it uses a system font of size 15.   |
| textColor             | UIColor   | Set the color of the text. By default, it uses `UIColor.blackColor()`.                                            |
| backgroundColor       | UIColor   | Set the background color of the date picker. By default, it is a clear color.                                     |
| minimumDate 		    | UIDate    | The minimum selectable date allowed by the date picker. Defaults to `NSDate.distantPast()`.                       |
| maximumDate		    | UIDate    | The maximum selectable date allowed by the date picker. Defaults to `NSDate.distantFuture()`.                     |
| locale		        | NSLocale  | The locale of the calendar used for formatting the date. By default, this uses the device's locale.               |

The following public methods are available for calling in your module:

| Method                					| Description                                           |
|:------------------------------------------|:------------------------------------------------------|
| reloadAllComponents() 					| Reloads all of the components of the date picker.		|
| setDate(date: NSDate, animated: Bool)     | Sets the current date of the date picker.             |

## Delegate

A class can implement `PIDatePickerDelegate` and the following method to respond to changes in user selection.

```swift
func pickerView(pickerView: PIDatePicker, didSelectRow row: Int, inComponent component: Int)
```

## Contributing

To report a bug or enhancement request, feel free to file an issue under the respective heading. 

If you wish to contribute to the project, fork this repo and submit a pull request. 

## License

HEDatePicker is available under the MIT license. See the LICENSE file for more info.
