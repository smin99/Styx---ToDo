//
//  IntExtension.swift
//  Styx
//
//  Created by HwangSeungmin on 1/5/19.
//  Copyright © 2019 Min. All rights reserved.
//

import Foundation

extension Int {
    func toDateString(dateString: String) -> String {
        let value: Int = self
        if dateString != "" {
            return dateString + "," + String(value)
        }
        return String(value)
    }
}
