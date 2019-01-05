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
}
