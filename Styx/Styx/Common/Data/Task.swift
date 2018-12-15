//
//  Task.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

class Task {
    var ID: Int64           // Primary key
    var LabelID: Int64      // labels are to search task more easily
    var Title: String       // name of the task
    var Due: Date           // Due date of the task
    var Detail: String      // Details for the
    var Notif: Int          // int for each choice; minute
    var isNotif: Bool       // false if there's no notification; false by default
    var isDone: Bool        // is the task finished; false if not done; false by default
    var isDeleted: Bool     // deleted task appear in trash; false by default; true if deleted
    
    init(ID: Int64 = 0, Title: String = "", Due: Date, Detail: String = "", Notif: Int = 0, isNotif: Bool = false, LabelID: Int64 = 0, isDone: Bool = false, isDeleted: Bool = false) {
        self.ID = ID
        self.LabelID = LabelID
        self.Title = Title
        self.Due = Due
        self.Detail = Detail
        self.Notif = Notif
        self.isNotif = isNotif
        self.isDone = isDone
        self.isDeleted = isDeleted
    }
}
