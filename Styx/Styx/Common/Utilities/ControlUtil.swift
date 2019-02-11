//
//  ControlUtil.swift
//  Styx
//
//  Created by HwangSeungmin on 12/31/18.
//  Copyright © 2018 Min. All rights reserved.
//

import SkyFloatingLabelTextField

class ControlUtil {
    // Define properties of text field - for required inputs - light green-blue
    static func setSkyFloatingTextFieldColor(textField: SkyFloatingLabelTextField, placeholder: String, title: String) {
        
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        textField.frame.size.height = 45
        
        textField.placeholder = placeholder
        textField.title = title
        
        textField.tintColor = overcastBlueColor // the color of the blinking cursor
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
    
    // Define properties of text field - for required inputs - light green-blue
    static func setSkyFloatingTextFieldColor(textField: SkyFloatingLabelTextField) {
        
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        textField.frame.size.height = 45
        
//        textField.tintColor = overcastBlueColor // the color of the blinking cursor
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
    
    // Define properties of text field - for other inputs - black color
    static func setSkyFloatingTextField(textField: SkyFloatingLabelTextField, placeholder: String, title: String) {
        
        textField.frame.size.height = 45
        
        textField.placeholder = placeholder
        textField.title = title
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return "\(dateFormatter.string(from: date))"
    }
    
    static func arrayToString(dates: [Int]) -> String {
        var rtv: String = ""
        for val in dates {
            if rtv != "" {
                rtv = rtv + ","
            }
            rtv = rtv + String(val)
        }
        return rtv
    }
    
    
    // receives the warning time index and returns the time in seconds
    static func warningDate(num: Int) -> Int {
        // ["30 minutes before", "1 hour before", "12 hours before", "1 day before", "3 days before", "a week before"]
        var rtv = 0
        
        switch num {
        case 0: // 30 minutes
            rtv = 60 * 30
        case 1: // 1 hour
            rtv = 60 * 60
        case 2: // 3 hours
            rtv = 60 * 60 * 3
        case 3: // 12 hours
            rtv = 60 * 60 * 12
        case 4: // 1 day
            rtv = 60 * 60 * 24
        case 5: // 3 days
            rtv = 60 * 60 * 24 * 3
        case 6: // a week
            rtv = 60 * 60 * 24 * 7
        default:
            rtv = 0
        }
        return rtv
    }
}
