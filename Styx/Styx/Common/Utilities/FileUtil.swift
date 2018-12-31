//
//  FileUtil.swift
//  Styx
//
//  Created by HwangSeungmin on 12/15/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

// Defines functions related to file utility: create/delete/copy file
class FileUtil {
    // Returns App's base Document directroy URL
    static func getDocumentDirectory() -> URL? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL else {
            return nil
        }
        return directory
    }
    
    // Returns data folder URL. If not exists, create one
    static func getDataFolder() -> URL? {
        if let directory = getDocumentDirectory() {
            let dataPath = directory.appendingPathComponent("data")
            if !FileManager.default.fileExists(atPath: dataPath.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    return nil
                }
            }
            return dataPath
        }
        return nil
    }
    
    
}
