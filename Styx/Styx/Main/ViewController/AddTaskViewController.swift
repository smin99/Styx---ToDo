//
//  AddTaskViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/28/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isNotif: Bool! = false
    var notif: Int!
    var labelID: Int64!
    var taskTitle: String!
    var taskDetail: String!
    var dateDue: Date!
    
    var datePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 1)
    
    var doneButton: UIBarButtonItem!
    
    let placeholders: Array<String> = ["Type Title".localized, "Type Details".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAdding))
        self.navigationItem.leftBarButtonItem = doneButton

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskTableViewCell") as! AddTaskTableViewCell
            cell.textField.borderStyle = .none
            cell.textField.placeholder = placeholders[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskNotifTableViewCell") as! TaskNotifTableViewCell
            cell.notifLabel.text = "Remind me at ".localized
            cell.notifSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
            return cell
        } else if datePickerIndexPath == indexPath && isNotif{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return isNotif ? 2 : 1
        } else if section == 2 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func switchIsChanged (_ sender: Any) {
        if !isNotif {
            isNotif = true
            tableView.insertRows(at: [datePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
        } else {
            isNotif = false
            tableView.deleteRows(at: [datePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
        }
    }
    
    @objc func doneAdding (_ sender: Any) {
        _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, LabelID: labelID, Title: taskTitle, Due: dateDue, Detail: taskDetail, Notif: notif, isNotif: isNotif, isDone: false, isDeleted: false))
        self.navigationController?.popViewController(animated: true)
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }

}
