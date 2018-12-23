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
    
    var taskIndex: Int = 0
    var taskTitle: String = ""
    var taskListForLabel: Array<Task>!
    var listForTask: Array<List>!
    var listNotDone: Array<List>!
    var listDone: Array<List>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  taskTitle + " Details"
        
        // initialize listDone / listNotDone arrays
        listDone = []
        listNotDone = []
        
        for list in listForTask {
            if list.isDone {
                listDone.append(list)
            } else {
                listNotDone.append(list)
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        taskListForLabel = MainViewController.mainView.labelList[MainViewController.mainView.labelIndex].taskList
//        listForTask = taskListForLabel[taskIndex].listList
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listForTask.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            if listForTask[indexPath.row].isDone {
                cell.checkButton.setImage(UIImage(named: "RadioButtonComplete"), for: .normal)
            } else {
                cell.checkButton.setImage(UIImage(named: "RadioButtonIncomplete"), for: .normal)
            }
            cell.titleTextField.text = listForTask[indexPath.row].Title
            cell.taskTableViewController = self
            cell.checkItem = self.listForTask[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCompletedListTableViewCell", for: indexPath) as! ShowCompletedListTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < listForTask.count {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("source=\(sourceIndexPath), dest=\(destinationIndexPath)")
        if destinationIndexPath.row < listForTask.count {
            let movedObject = listForTask[sourceIndexPath.row]
            listForTask.remove(at: sourceIndexPath.row)
            listForTask.insert(movedObject, at: destinationIndexPath.row)
        } else {
            tableView.reloadData()
        }
    }
    
    // New Check Item add
    func addCheckItem() {
        listForTask.append(List(Title: "", isDone: false))
        let appendIndex = IndexPath(row: listForTask.count - 1, section: 0)
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
        if let index = listForTask.firstIndex(where: { $0.ID == item.ID }) {
            if index == listForTask.count - 1 {   // 마지막 아이템이면 추가
                addCheckItem()
            } else {                            // 다음 아이템으로 이동
                let indexPath = IndexPath(row: index + 1, section: 0)
                tableView.scrollToRow(at: indexPath, at: .none, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    if let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                        cell.titleTextField.becomeFirstResponder()
                    }
                })
            }
        }
    }
    
    // Delete Button Clicked - Delete current item
    public func deleteCheckItem(item: List) {
        
        if let index = listForTask.firstIndex(where: { $0.ID == item.ID }) {
            listForTask.remove(at: index)
            tableView.reloadData()
        }
    }
}
