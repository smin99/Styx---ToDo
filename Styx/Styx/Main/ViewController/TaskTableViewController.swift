//
//  TaskTableViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import DLRadioButton

class TaskTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var taskTitle: String = ""
    var taskID: Int64 = 0
    var listForTask: Array<List>!
    var listNotDone: Array<List>!
    var listDone: Array<List>!
    var showComplete: Bool!
    
    var aboutBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAvoidingKeyboard()
        self.hideKeyboardWhenTappedAround()
        navigationItem.title =  taskTitle + " Details"
        
        // initialize listDone / listNotDone arrays
        listDone = []
        listNotDone = []
        showComplete = false
        
        for list in listForTask {
            if list.isDone {
                listDone.append(list)
            } else {
                listNotDone.append(list)
            }
        }
        
        aboutBarButton = UIBarButtonItem(image: UIImage(named: "AboutIcon"), style: .plain, target: self, action: #selector(settingTask))
        self.navigationItem.rightBarButtonItem = aboutBarButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableview design
        tableView.separatorStyle = .singleLine
        
        self.tableView.isEditing = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listNotDone.count < 1 ? 1 : listNotDone.count + 1
        }
        else if section == 1 {
            if showComplete {
                return listDone.count
            } else {
                return 0
            }
        }
        else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // List Not Done
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell

            if indexPath.row < listNotDone.count {
                cell.titleTextField.text = listNotDone[indexPath.row].Title
                cell.titleTextField.borderStyle = .none
                cell.taskTableViewController = self
                cell.checkItem = listNotDone[indexPath.row]
                cell.checkIndex = indexPath.row
                cell.displayTitle()
            } else {
                cell.titleTextField.text = ""
                cell.titleTextField.placeholder = "Type new list".localized
                cell.titleTextField.borderStyle = .none
                cell.taskTableViewController = self
                cell.checkItem = List(ID: 0, TaskID: taskID, Title: "", isDone: false, index: indexPath.row)
                cell.checkIndex = indexPath.row
                cell.displayTitle()
            }
            
            return cell
        }
        // List Done
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.titleTextField.text = listDone[indexPath.row].Title
            cell.taskTableViewController = self
            cell.checkItem = listDone[indexPath.row]
            cell.checkIndex = indexPath.row
            cell.displayTitle()
            
            return cell
        }
        // Show Completed Button Cell
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCompletedListTableViewCell", for: indexPath) as! ShowCompletedListTableViewCell
            cell.showCompleteButton.titleLabel?.text = isCompleteShow()

            return cell
        }
    }
    
    @IBAction func showCompleteButtonAction(_ sender: Any) {
        showComplete = !showComplete
        tableView.reloadData()
    }
    
    func isCompleteShow() -> String {
        if showComplete {
            return "Hide Complete".localized
        }
        else {
            return "Show Complete".localized
        }
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        if indexPath.section == 2 {
////            showComplete = true
////            tableView.reloadData()
////        }
//    }
    
    // New Check Item add
    func addCheckItem() {
        listNotDone.append(List(Title: "", isDone: false))
        let appendIndex = IndexPath(row: listNotDone.count + 1, section: 0)
        tableView.insertRows(at: [appendIndex], with: .automatic)
        tableView.scrollToRow(at: appendIndex, at: .none, animated: true)
        
        // Set the focus on new item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if let cell = self.tableView.cellForRow(at: appendIndex) as? ListTableViewCell {
                cell.titleTextField.becomeFirstResponder()
            }
        })
    }
    
    // Enter key for new item input - move to next item, if last add new
    func nextCheckItem(item: List) {
        let index = listNotDone.firstIndex(where: { $0.ID == item.ID })
        if index == nil {
            listNotDone.append(item)
            tableView.reloadData()
            if let cell = self.tableView.cellForRow(at: IndexPath(row: self.tableView.numberOfRows(inSection: 0)-1, section: 0)) as? ListTableViewCell {
                cell.titleTextField.becomeFirstResponder()
            }
        } else {                            // move to next item
            let indexPath = IndexPath(row: index! + 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                    cell.titleTextField.becomeFirstResponder()
                }
            })
        }
    }
    
    // Delete Button Clicked - Delete current item (Both DB and data)
    public func deleteCheckItem(item: List) {
        
        if let index = listNotDone.firstIndex(where: { $0.ID == item.ID }) {
            listNotDone.remove(at: index)
            _ = MainViewController.Database.DeleteList(ID: item.ID)
            tableView.reloadData()
        }
        else if let index = listDone.firstIndex(where: { $0.ID == item.ID }) {
            listDone.remove(at: index)
            _ = MainViewController.Database.DeleteList(ID: item.ID)
            tableView.reloadData()
        }
    }
    
    // Move the row - Both DB and data
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section > 0  {
            return false
        } else if indexPath.row < listNotDone.count {
            return true
        } else {
            return false
        }
    }
    
    func increaseIndexByOne(index1: Int, index2: Int) {
        // when the row moves up, increases the index of the range.
        // when the row moves down, decreases the index of the range.
        // exclude the row that is moving
        let smallerIndex = index1 < index2 ? index1 + 1 : index2
        let greaterIndex = index1 < index2 ? index2 : index1 - 1
        
        var listRange: Array<List>! = []
        for i in smallerIndex...greaterIndex {
            listRange.append(listNotDone[i])
        }
        
        for listItem in listRange {
            listItem.index = index1 < index2 ? listItem.index - 1 : listItem.index + 1
            _ = MainViewController.Database.UpsertList(list: listItem)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // prevent the movement between section
        if sourceIndexPath.section == destinationIndexPath.section {
            
            print("source=\(sourceIndexPath), dest=\(destinationIndexPath)")
            if sourceIndexPath.section == 0 && destinationIndexPath.section == 0 {
                if sourceIndexPath.row == destinationIndexPath.row {
                    //return
                }
                else if destinationIndexPath.row < listNotDone.count {
                    let movedObject = listNotDone[sourceIndexPath.row]
                    
                    // Interchange the index and update DB
                    movedObject.index = listNotDone[destinationIndexPath.row].index
                    _ = MainViewController.Database.UpsertList(list: movedObject)
                    increaseIndexByOne(index1: sourceIndexPath.row, index2: destinationIndexPath.row)
                
                    listNotDone.remove(at: sourceIndexPath.row)
                    listNotDone.insert(movedObject, at: destinationIndexPath.row)
                    
                } else {
                    tableView.reloadData()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                textField.resignFirstResponder()
                cell.titleTextField.becomeFirstResponder()
            }
        })
        return true
    }
    
    @objc func settingTask(_ sender: Any) {
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        let tasks = MainViewController.Database.GetTaskList()
        let task: Task = tasks[tasks.firstIndex(where: {$0.ID == self.taskID})!]
        viewcontroller.taskID = task.ID
        viewcontroller.labelID = task.LabelID
        viewcontroller.taskTitle = self.taskTitle
        viewcontroller.taskDetail = task.Detail
        
        viewcontroller.isDueShow = task.Due == Date(timeIntervalSince1970: 0) ? false : true
        viewcontroller.dateDue = task.Due
        viewcontroller.isNotifShow = task.isNotif
        viewcontroller.notif = task.NotifDate
        viewcontroller.isRepeat = task.isRepeat
        viewcontroller.repeatString = task.dateToRepeat
        
        viewcontroller.isEditingPage = true
        viewcontroller.navigationItem.title = "Edit Task"
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
}
