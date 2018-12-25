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
    var listForTask: Array<List>!
    var listNotDone: Array<List>!
    var listDone: Array<List>!
    var showComplete: Bool = false
    
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
        
        self.tableView.isEditing = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listNotDone.count
        }
        else if section == 1 {
            return listDone.count
        }
        else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // List Not Done
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.checkButton.setImage(UIImage(named: "RadioButtonIncomplete"), for: .normal)
            cell.titleTextField.text = listNotDone[indexPath.row].Title
            cell.taskTableViewController = self
            cell.checkItem = listNotDone[indexPath.row]
            
            return cell
        }
        // List Done
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.checkButton.setImage(UIImage(named: "RadioButtonComplete"), for: .normal)
            cell.titleTextField.text = listDone[indexPath.row].Title
            cell.taskTableViewController = self
            cell.checkItem = listDone[indexPath.row]
            
            return cell
        }
        // Show Completed Button Cell
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCompletedListTableViewCell", for: indexPath) as! ShowCompletedListTableViewCell
            if showComplete {
                cell.showCompleteButton.titleLabel?.text = "Hide Complete".localized
            } else {
                cell.showCompleteButton.titleLabel?.text = "Show Complete".localized
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            showComplete = true
            tableView.reloadData()
        }
    }
    
    // New Check Item add
    func addCheckItem() {
        listNotDone.append(List(Title: "", isDone: false))
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
        if let index = listNotDone.firstIndex(where: { $0.ID == item.ID }) {
            if index == listNotDone.count - 1 {   // 마지막 아이템이면 추가
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
        if indexPath.row < listNotDone.count && indexPath.section == 0 {
            return true
        } else if indexPath.row < listDone.count && indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // prevent the movement between section
        if sourceIndexPath.section == destinationIndexPath.section {
            
            print("source=\(sourceIndexPath), dest=\(destinationIndexPath)")
            if sourceIndexPath.section == 0 && destinationIndexPath.section == 0 {
                if destinationIndexPath.row < listNotDone.count {
                    let movedObject = listNotDone[sourceIndexPath.row]
                    listNotDone.remove(at: sourceIndexPath.row)
                    listNotDone.insert(movedObject, at: destinationIndexPath.row)
                } else {
                    tableView.reloadData()
                }
            }
            else if sourceIndexPath.section == 1 && destinationIndexPath.section == 1 {
                if destinationIndexPath.row < listDone.count {
                    let movedObject = listDone[sourceIndexPath.row]
                    listDone.remove(at: sourceIndexPath.row)
                    listDone.insert(movedObject, at: destinationIndexPath.row)
                } else {
                    tableView.reloadData()
                }
            }
            
        }
    }
    
}
