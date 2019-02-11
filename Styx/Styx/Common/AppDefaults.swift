//
//  AppDefaults.swift
//  Styx
//
//  Created by HwangSeungmin on 2/11/19.
//  Copyright © 2019 Min. All rights reserved.
//

import Foundation

// UserDefaults to Save Setting Values
class AppDefaults {
    static let UserID               = "UserID"              // String, Firebase Login ID
    static let DeviceID             = "DeviceID"            // String, UIDevice.current.identifierForVendor
    
    static let warningTime          = "WarningTime"         // Time to display the warning sign
    
    static func getDefaults(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    static func setDefaults(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getDefaultsBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func setDefaultsBool(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getDefaultsInt(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func setDefaultsInt(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
