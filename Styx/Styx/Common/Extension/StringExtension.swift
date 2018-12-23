//
//  StringExtension.swift
//  Styx
//
//  Created by HwangSeungmin on 12/17/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation
import UIKit

// Extension of NSLocalizedString for String objects
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func normalAttribute() -> NSAttributedString {
        let fontAttribute = [ NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)! ]
        let attributeString = NSAttributedString(string: self, attributes: fontAttribute)
        return attributeString
    }
    
    func strikeThrough() -> NSAttributedString {
        //let attributeString =  NSMutableAttributedString(string: self)
        let fontAttribute = [ NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)! ]
        let attributeString = NSMutableAttributedString(string: self, attributes: fontAttribute)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func boldAttribute() -> NSAttributedString {
        let fontAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0) ]
        let attributeString = NSAttributedString(string: self, attributes: fontAttribute)
        return attributeString
    }
}
