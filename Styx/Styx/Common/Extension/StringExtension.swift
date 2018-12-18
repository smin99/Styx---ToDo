//
//  StringExtension.swift
//  Styx
//
//  Created by HwangSeungmin on 12/17/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

// Extension of NSLocalizedString for String objects
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
