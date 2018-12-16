//
//  Image.swift
//  Styx
//
//  Created by HwangSeungmin on 12/14/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

// additional information that will be part of Task
class Image {
    var ID: Int64
    var TaskID: Int64
    var fileName: String
    
    init(ID: Int64 = 0, TaskID: Int64 = 0, fileName: String = "") {
        self.ID = ID
        self.TaskID = TaskID
        self.fileName = fileName
    }
}
