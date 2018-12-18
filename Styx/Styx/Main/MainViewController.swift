//
//  MainViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/12/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import EZLoadingActivity

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
//    // Test case
//    let label1 = Label(ID: 1, Title: "", ColorID: 1)//  (ID: 1, Title: "homework", ColorID: 1)
//    let label2 = Label(ID: 2, Title: "project", ColorID: 4)
//    let task1 = Task(Title: "Review hw3", Due: Date(timeIntervalSinceNow: 30000000), Notif: 1, LabelID: 1)  // case 1: task not due
//    let task2 = Task(Title: "Work on project", Due: Date(timeIntervalSinceNow: 2000000), LabelID: 2)    // case 2: task not due
//    let task3 = Task(Title: "Read chapter 3", Due: Date(timeIntervalSinceNow: -3000), LabelID: 1)   // case 3: task due
//    let task4 = Task(Title: "Write journal", Due: Date(timeIntervalSinceNow: -1000), LabelID: 1)    // case 4: task due
//    lazy var tasks: [Task] = [task1, task2, task3, task4]
    
    var names = [ "AAA", "BBB", "CC" ]
    
    static var Database: TaskDBProtocol!
    static var mainView: MainViewController!
    
    var labelList: Array<Label>!
    var taskList: Array<Task>!
    var listList: Array<List>!
    var imageList: Array<Image>!
    
    var isInitData: Bool = false
    var openedLabelIndex: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainViewController.mainView = self
        
        // Initialize DB Object
        if(MainViewController.Database == nil) {
            if let dataUrl = FileUtil.getDataFolder() {
                let dbUrl = dataUrl.appendingPathComponent("todo.sqlite3")
                MainViewController.Database = TaskDB(dbPath: dbUrl.absoluteString)
            }
        }
        
        // Initialize if the DB is not opened
        if MainViewController.Database != nil && !MainViewController.Database.IsDBOpened {
            let bOpen = MainViewController.Database.OpenDB()
            print("DBOpen Return: \(bOpen), isOpen: \(MainViewController.Database.IsDBOpened), Error Message: \(MainViewController.Database.LastErrorMessage)")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
//        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: showEditing(sender: editBarButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will disappear")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        DispatchQueue.global().async {
            
            self.labelList = MainViewController.Database.GetLabelList()
            self.taskList = MainViewController.Database.GetTaskList()
            self.listList = MainViewController.Database.GetListList()
            self.imageList = MainViewController.Database.GetImageList()
            
            // when labelList is empty, make a test case
            if self.labelList.count == 0 {
                _ = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: "Homework", ColorID: 0))
                let id1 = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: "Project", ColorID: 0))
                let id2 = MainViewController.Database.UpsertTask(task: Task(ID: 0, Title: "Chapter 3", Due: Date(), Detail: "", Notif: 0, isNotif: false, LabelID: id1, isDone: false, isDeleted: false))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "34", isDone: false))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "35", isDone: true))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "36", isDone: false))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "37", isDone: false))
                _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, Title: "Chapter 5", Due: Date(), Detail: "", Notif: 0, isNotif: false, LabelID: id1))
                _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, Title: "Chapter 6", Due: Date(), Detail: "", Notif: 0, isNotif: false, LabelID: id1))
                _ = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: "Shopping List", ColorID: 0))
            }
            
            // Map Task Object to the Label Object
            for task in self.taskList {
                if let index = self.labelList.index(where: { $0.ID == task.LabelID}){
                    self.labelList[index].taskList.append(task)
                }
            }
            
            // Map List Object to the corresponding Task Obejct
            for list in self.listList {
                if let index = self.taskList.index(where: {$0.ID == list.TaskID}) {
                    self.taskList[index].listList.append(list)
                }
            }
            
            // Map Image Object to the corresponding Task Object
            for image in self.imageList {
                if let index = self.taskList.index(where: {$0.ID == image.TaskID}) {
                    self.taskList[index].imageList.append(image)
                }
            }
            
            DispatchQueue.main.sync {
                EZLoadingActivity.hide()
                
                self.isInitData = true
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("View did disappear")
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if labelList == nil { return 0 }
        
        return openedLabelIndex == nil ? labelList.count : (labelList.count + labelList[openedLabelIndex!.row].taskList.count)
    }
    
    public func createLabelCell(index: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as! LabelTableViewCell
        cell.titleLabel.text = labelList[index].Title
        cell.openImageView.image = UIImage(named: labelList[index].isOpened ? "LabelOpenIcon" : "LabelCloseIcon")
        cell.labelItem = labelList[index]
        return cell
    }
    
    public func createTaskCell(labelIndex: Int, index: Int) -> UITableViewCell {
        let labelItem = labelList[labelIndex]
        
        // count the list completed and save it
        var numListCompleted = 0
        for list in labelList[labelIndex].taskList[index].listList {
            if list.isDone { numListCompleted = numListCompleted + 1 }
        }
        labelList[labelIndex].taskList[index].listCompleted = numListCompleted
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell") as! taskTableViewCell
        cell.titleLabel.text = labelItem.taskList[index].Title
        cell.dueLabel.text = labelItem.taskList[index].Due.toString(dateformat: "MM-DD-YY")
        
        let progressFloat: Float = numListCompleted == 0 ? 0.0 : Float(numListCompleted / labelItem.taskList[index].listList.count)
        cell.taskProgressBar.progress = progressFloat
        cell.taskProgressPercentageLabel.text = NSString(format: "%.2f", progressFloat * 100) as String + " %"
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var labelIndex: Int = 0
        var taskIndex: Int = -1
        
        if let openIndex = openedLabelIndex {
            let count = labelList[openIndex.row].taskList.count
            if openIndex.row >= indexPath.row { labelIndex = indexPath.row }
            else if openIndex.row + count < indexPath.row { labelIndex = indexPath.row - count }
            else {
                labelIndex = openIndex.row
                taskIndex = indexPath.row - openIndex.row - 1
            }
        } else {
            labelIndex = indexPath.row
        }
        
        if taskIndex >= 0 {
            return createTaskCell(labelIndex: labelIndex, index: taskIndex)
        }
        
        return createLabelCell(index: labelIndex)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = tableView.cellForRow(at: indexPath) as? LabelTableViewCell {
            return 50.0
        }
        
        return 60.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? LabelTableViewCell {
            if let openedIndexPath = openedLabelIndex {
                labelList[openedIndexPath.row].isOpened = false
                openedLabelIndex = nil
                if openedIndexPath == indexPath {
                    tableView.reloadData()
                    return
                }
            }
            
            if labelList[indexPath.row].taskList.count > 0 {
                labelList[indexPath.row].isOpened = true
                openedLabelIndex = indexPath
            }
            tableView.reloadData()
        }
        else if let _ = tableView.cellForRow(at: indexPath) as? taskTableViewCell {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskTableViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func tableEditing(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let labelID: Int64 = labelList[indexPath.row].ID
            let taskArray: Array<Task> = labelList[indexPath.row].taskList
            if !taskArray.isEmpty{
                let maxIndex: Int = taskArray.count - 1
                
                // loops through task array in label and delete all tasks in DB
                for index in 0...maxIndex {
                    if (labelList[indexPath.row].isOpened) {
                        self.tableView.deleteRows(at: [IndexPath(row: indexPath.row + maxIndex - index, section: 0)], with: .automatic)
                    }
                    
                    let id: Int64 = taskArray[index].ID
                    _ = MainViewController.Database.DeleteTask(id: id)
                }
            }
            
            openedLabelIndex = nil
            _ = MainViewController.Database.DeleteLabel(labID: labelID)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
