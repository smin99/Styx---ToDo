//
//  List.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

class List {
    var ID: Int64
    var TaskID: Int64
    var Title: String
    var isDone: Bool
    
    init(ID: Int64 = 0, TaskID: Int64 = 0, Title: String = "", isDone: Bool = false) {
        self.ID = ID
        self.TaskID = TaskID
        self.Title = Title
        self.isDone = isDone
    }
}
