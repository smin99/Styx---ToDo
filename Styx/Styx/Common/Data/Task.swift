//
//  Task.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

class Task {
    var Title: String       // name of the task
    var Due: Date           // Due date of the task
    var Notif: Date
    var Label: [String]     // labels are to search task more easily
    
    init(Title: String = "", Due: Date, Notif: Date, Label: [String] = []) {
        self.Title = Title
        self.Due = Due
        self.Notif = Notif
        self.Label = Label
    }
}
