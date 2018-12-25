//
//  TaskDB.swift
//  Styx
//
//  Created by HwangSeungmin on 12/14/18.
//  Copyright © 2018 Min. All rights reserved.
//

import Foundation
import SQLite

// 프로토콜 정의 - sqlite & google cloud database 지원
protocol TaskDBProtocol {
    var IsDBOpened: Bool { get }
    var LastErrorMessage: String { get }
    
    func OpenDB() -> Bool
    func GetLabelList() -> Array<Label>
    func UpsertLabel(label: Label) -> Int64
    func DeleteLabel(labID: Int64) -> Bool
    
    func GetTaskIDList() -> Array<Int64>
    func GetTaskList() -> Array<Task>
    func GetDoneTaskList() -> Array<Task>
    func GetDeletedTaskList() -> Array<Task>
    func UpsertTask(task: Task) -> Int64
    func DeleteTask(id: Int64) -> Bool
    
    func GetList(listID: Int64) -> List?
    func GetListList() -> Array<List>
    func UpsertList(list: List) -> Int64
    func UpsertList(list1: List, list2: List) -> Bool
    func DeleteList(ID: Int64) -> Bool
    func DeleteList(taskID: Int64) -> Bool
    
    func GetImageIDList(taskID: Int64) -> Image?
    func GetImageList() -> Array<Image>
    func UpsertImage(image: Image) -> Int64
    func DeleteImage(ID: Int64) -> Bool
}

// SQLite 구현 클래스
class TaskDB : TaskDBProtocol {
    
    private var db: Connection? = nil
    
    private let labelTable = Table("Category")
    private let labelID = Expression<Int64>("ID")
    private let labelTitle = Expression<String>("Title")
    private let labelColorID = Expression<Int>("ColorID")
    
    private let taskTable = Table("Task")
    private let taskID = Expression<Int64>("ID")
    private let taskTitle = Expression<String>("Title")
    private let taskDetail = Expression<String>("Detail")
    private let taskDue = Expression<Date>("Due")
    private let taskLabelID = Expression<Int64>("LabelID")
    private let taskNotif = Expression<Int>("Notif")
    private let taskIsNotif = Expression<Bool>("isNotif")
    private let taskIsDone = Expression<Bool>("isDone")
    private let taskIsDeleted = Expression<Bool>("isDeleted")
    
    private let listTable = Table("List")
    private let listID = Expression<Int64>("ID")
    private let listTaskID = Expression<Int64>("TaskID")
    private let listTitle = Expression<String>("Title")
    private let listIsDone = Expression<Bool>("isDone")
    private let listIndex = Expression<Int>("index")
    
    private let imageTable = Table("Image")
    private let imageID = Expression<Int64>("ID")
    private let imageTaskID = Expression<Int64>("TaskID")
    private let imageFileName = Expression<String>("fileName")
    
    private var dbPath: String
    private var isDBOpened: Bool
    private var lastErrorMessage: String
    
    
    convenience init() {
        self.init(dbPath: "")
    }
    
    init(dbPath: String) {
        self.dbPath = dbPath
        self.isDBOpened = false
        self.lastErrorMessage = ""
    }
    
    var IsDBOpened: Bool { return isDBOpened }
    var LastErrorMessage: String { return lastErrorMessage }
    
    func OpenDB() -> Bool {
        
        do {
            db = try Connection(dbPath)
            
            try db?.run(labelTable.create(ifNotExists: true) { t in
                t.column(labelID, primaryKey: true)
                t.column(labelTitle)
                t.column(labelColorID)
            })
            
            try db?.run(taskTable.create(ifNotExists: true) { t in
                t.column(taskID, primaryKey: true)
                t.column(taskTitle)
                t.column(taskDetail)
                t.column(taskDue)
                t.column(taskLabelID)
                t.column(taskNotif)
                t.column(taskIsNotif)
                t.column(taskIsDone)
                t.column(taskIsDeleted)
            })
            
            try db?.run(listTable.create(ifNotExists: true) { t in
                t.column(listID, primaryKey: true)
                t.column(listTaskID)
                t.column(listTitle)
                t.column(listIsDone)
                t.column(listIndex)
            })
            
            try db?.run(imageTable.create(ifNotExists: true) { t in
                t.column(imageID, primaryKey: true)
                t.column(imageTaskID)
                t.column(imageFileName)
            })
            
            isDBOpened = true
        }
        catch let error
        {
            isDBOpened = false
            lastErrorMessage = error.localizedDescription
        }
        
        return isDBOpened
    }
    
    
    
    //
    // Label 관련 CRUD 함수
    //
    func GetLabelList() -> Array<Label> {
        
        var labelList: Array<Label> = Array<Label>()
        if let db = self.db {
            do {
                for lab in try db.prepare(labelTable) {
                    let label = Label(ID: lab[labelID], Title: lab[labelTitle])
                    labelList.append(label)
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return labelList
    }
    
    func UpsertLabel(label: Label) -> Int64 {
        
        var retVal: Int64 = 0
        if let db = self.db {
            do {
                if label.ID == 0 {
                    let insert = labelTable.insert(labelTitle <- label.Title, labelColorID <- label.ColorID)
                    retVal = try db.run(insert)
                } else {
                    let row = labelTable.filter(labelID == label.ID)
                    try db.run(row.update(labelTitle <- label.Title))
                    retVal = label.ID
                }
            } catch let error {
                retVal = 0
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    func DeleteLabel(labID: Int64) -> Bool {
        
        var retVal: Bool = false
        if let db = self.db {
            do {
                let taskRow = taskTable.filter(taskLabelID == labID)
                try db.run(taskRow.update(taskLabelID <- 0))
                
                let row = labelTable.filter(labelID == labID)
                try db.run(row.delete())
                retVal = true
            } catch let error {
                retVal = false
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    
    
    //
    // Task 관련 CRUD 함수
    //
    func GetTaskIDList() -> Array<Int64> {
        
        var list: Array<Int64> = Array<Int64>()
        if let db = self.db {
            do {
                for task in try db.prepare("SELECT ID FROM Task") {
                    if let ID = task[0] as? Int64 {
                        list.append(ID)
                    }
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return list
    }
    
    func GetTaskList() -> Array<Task> {
        
        var list: Array<Task> = Array<Task>()
        if let db = self.db {
//            let labelList = GetLabelList();
            do {
                for task in try db.prepare(taskTable) {
//                    var labelTitle: String = ""
//                    if task[taskLabelID] > 0 {
//                        if let label = labelList.first(where: { $0.ID == task[taskLabelID] }) {
//                            labelTitle = label.Title
//                        }
//                    }
                    let item = Task(ID: task[taskID], Title: task[taskTitle], Due: task[taskDue], Detail: task[taskDetail],
                                    Notif: task[taskNotif], isNotif: task[taskIsNotif], LabelID: task[taskLabelID], isDone: task[taskIsDone], isDeleted: task[taskIsDeleted])
                    list.append(item)
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return list
    }
    
    func GetDoneTaskList() -> Array<Task> {
        
        var list: Array<Task> = Array<Task>()
        if let db = self.db {
            do {
                for task in try db.prepare(taskTable) {
                    let item = Task(ID: task[taskID], Title: task[taskTitle], Due: task[taskDue], Detail: task[taskDetail],
                                    Notif: task[taskNotif], isNotif: task[taskIsNotif], LabelID: task[taskLabelID], isDone: task[taskIsDone], isDeleted: task[taskIsDeleted])
                    list.append(item)
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return list
    }
    
    // 특정날짜 이전 부터 존재하는 휴지통 메모 객체를 반환
    func GetDeletedTaskList() -> Array<Task> {
        
        var list: Array<Task> = Array<Task>()
        if let db = self.db {
            //let categoryList = GetCategoryList();
            do {
                for task in try db.prepare(taskTable.filter(taskIsDeleted == true)) {
                    //var categoryName: String = ""
                    //if let category = categoryList.first(where: { $0.ID == memo[memoCategoryID] }) {
                    //    categoryName = category.Name
                    //}
                    let item = Task(ID: task[taskID], Title: task[taskTitle], Due: task[taskDue], Detail: task[taskDetail],
                                    Notif: task[taskNotif], isNotif: task[taskIsNotif], LabelID: task[taskLabelID], isDone: task[taskIsDone], isDeleted: task[taskIsDeleted])
                    list.append(item)
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return list
    }
    
    func UpsertTask(task: Task) -> Int64 {
        
        var retVal: Int64 = 0
        if let db = self.db {
            do {
                if task.ID == 0 {
                    let insert = taskTable.insert(taskTitle <- task.Title, taskDue <- task.Due, taskDetail <- task.Detail,
                                                  taskNotif <- task.Notif, taskIsNotif <- task.isNotif, taskLabelID <- task.LabelID,
                                                  taskIsDone <- task.isDone, taskIsDeleted <- task.isDeleted)
                    retVal = try db.run(insert)
                } else {
                    let row = taskTable.filter(taskID == task.ID)
                    try db.run(row.update(taskTitle <- task.Title, taskDue <- task.Due, taskDetail <- task.Detail,
                                          taskNotif <- task.Notif, taskIsNotif <- task.isNotif, taskLabelID <- task.LabelID,
                                          taskIsDone <- task.isDone, taskIsDeleted <- task.isDeleted))
                    retVal = task.ID
                }
            } catch let error {
                retVal = 0
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    func DeleteTask(id: Int64) -> Bool {
        
        var retVal: Bool = false
        if let db = self.db {
            do {
                let row = taskTable.filter(taskID == id)
                try db.run(row.delete())
                retVal = true
            } catch let error {
                retVal = false
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    
    
    //
    // List 관련 CRUD 함수
    //
    func GetList(listID: Int64) -> List? {
        
        if let db = self.db {
            do {
                for list in try db.prepare(listTable.filter(listTaskID == taskID)) {
                    return List(ID: list[self.listID], TaskID: list[listTaskID], Title: list[listTitle], isDone: list[listIsDone], index: list[listIndex])
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return nil
    }
    
    func GetListList() -> Array<List> {
        var listList: Array<List> = Array<List>()
        if let db = self.db {
            do {
                for list in try db.prepare(listTable) {
                    let item = List(ID: list[listID], TaskID: list[listTaskID], Title: list[listTitle], isDone: list[listIsDone], index: list[listIndex])
                    listList.append(item)
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return listList
    }
    
    func UpsertList(list: List) -> Int64 {
        
        var retVal: Int64 = 0
        if let db = self.db {
            do {
                if list.ID == 0 {
                    let insert = listTable.insert(listTaskID <- list.TaskID, listTitle <- list.Title, listIsDone <- list.isDone, listIndex <- list.index)
                    retVal = try db.run(insert)
                } else {
                    let row = listTable.filter(listID == list.ID)
                    try db.run(row.update(listID <- list.ID, listTaskID <- list.TaskID, listTitle <- list.Title, listIsDone <- list.isDone, listIndex <- list.index))
                    retVal = list.ID
                }
            } catch let error {
                retVal = 0
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    func UpsertList(list1: List, list2: List) -> Bool {
        
        var retVal: Bool = false
        if let db = self.db {
            do {
                let index = list1.index
                let row1 = listTable.filter(listID == list1.ID)
                let row2 = listTable.filter(listID == list2.ID)
                
                try db.run(row1.update(listIndex <- list2.index))
                try db.run(row2.update(listIndex <- index))
            } catch let error {
                retVal = false
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    func DeleteList(ID: Int64) -> Bool {
        
        var retVal: Bool = false
        if let db = self.db {
            do {
                let row = listTable.filter(listID == ID)
                try db.run(row.delete())
                retVal = true
            } catch let error {
                retVal = false
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    func DeleteList(taskID: Int64) -> Bool {
        
        var retVal: Bool = false
        if let db = self.db {
            do {
                let row = listTable.filter(self.taskID == taskID)
                try db.run(row.delete())
                retVal = true
            } catch let error {
                retVal = false
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    
    
    //
    // Image 관련 CRUD 함수
    //
    func GetImageIDList(taskID: Int64) -> Image? {
        if let db = self.db {
            do {
                for image in try db.prepare(imageTable.filter(imageTaskID == taskID)) {
                    return Image(ID: image[imageID], TaskID: image[imageTaskID], fileName: image[imageFileName])
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return nil
    }
    
    func GetImageList() -> Array<Image> {
        var imageList: Array<Image> = Array<Image>()
        if let db = self.db {
            do {
                for image in try db.prepare(imageTable) {
                    let label = Image(ID: image[imageID], TaskID: image[imageTaskID], fileName: image[imageFileName])
                    imageList.append(label)
                }
            } catch let error {
                lastErrorMessage = error.localizedDescription
            }
        }
        return imageList
    }
    
    func UpsertImage(image: Image) -> Int64 {
        
        var retVal: Int64 = 0
        if let db = self.db {
            do {
                if image.ID == 0 {
                    let insert = imageTable.insert(imageID <- image.ID, imageTaskID <- image.TaskID, imageFileName <- image.fileName)
                    retVal = try db.run(insert)
                } else {
                    let row = imageTable.filter(imageID == image.ID)
                    try db.run(row.update(imageID <- image.ID, imageTaskID <- image.TaskID, imageFileName <- image.fileName))
                    retVal = image.ID
                }
            } catch let error {
                retVal = 0
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
    
    func DeleteImage(ID: Int64) -> Bool {
        
        var retVal: Bool = false
        if let db = self.db {
            do {
                let row = imageTable.filter(imageID == ID)
                try db.run(row.delete())
                retVal = true
            } catch let error {
                retVal = false
                lastErrorMessage = error.localizedDescription
            }
        }
        return retVal
    }
}
