//
//  Task.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation

// Second Data Structure; contains most information
class Task {
    var ID: Int64                   // Primary key
    var LabelID: Int64              // labels are to search task more easily
    var Title: String               // name of the task
    var Due: Date                   // Due date of the task
    var Detail: String              // Details for the
    var Notif: Int                  // int for each choice; minute
    var isNotif: Bool               // false if there's no notification; false by default
    var isDone: Bool                // is the task finished; false if not done; false by default
    var isDeleted: Bool             // deleted task appear in trash; false by default; true if deleted
    var isRepeat: Bool              // repeat the task?
    var dateToRepeat: Int           // which date to repeat: 0 for All day, 1 for weekdays, 2 for weekends, 10 for weekly, 11 for monthly, 12 for yearly
                                    // 3 for Monday, 4 for Tuesday, 5 for Wednesday, 6 for Thursday, 7 for Friday, 8 for Saturday, 9 for Sunday
                                    // if more than one date but neither weekdays or weekends, put them into one number
                                    // ex) Monday, Tuesday --> 34
                                    // ex) Tuesday, Wednesday, Friday --> 457
    
    var listList: Array<List>!
    var imageList: Array<Image>!
    var listCompleted: Int!
    
    init(ID: Int64 = 0, LabelID: Int64 = 0, Title: String = "", Due: Date, Detail: String = "", Notif: Int = 0, isNotif: Bool = false, isDone: Bool = false, isDeleted: Bool = false, listCompleted: Int = 0, isRepeat: Bool = false, dateToRepeat:Int = 0) {
        self.ID = ID
        self.LabelID = LabelID
        self.Title = Title
        self.Due = Due
        self.Detail = Detail
        self.Notif = Notif
        self.isNotif = isNotif
        self.isDone = isDone
        self.isDeleted = isDeleted
        self.listCompleted = listCompleted
        self.isRepeat = isRepeat
        self.dateToRepeat = dateToRepeat
        
        listList = Array<List>()
        imageList = Array<Image>()
//        listCompleted = 0
    }
}
