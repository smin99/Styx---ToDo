//
//  AddTaskViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/28/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import SCLAlertView

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isNotifShow: Bool! = false
    var isDueShow: Bool! = false
    var notif: Date! = Date()
    var labelID: Int64!
    var taskTitle: String! = ""
    var taskDetail: String! = ""
    var dateDue: Date! = Date()
    var repeatInt: Int!
    
    var dueDatePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 1)
    var datePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 2)
    
    var doneButton: UIBarButtonItem!
    
    let placeholders: Array<String> = ["Type Title".localized, "Type Details".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAdding))
        self.navigationItem.rightBarButtonItem = doneButton

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // First section: Title and Details Text fields
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskTableViewCell") as! AddTaskTableViewCell
            cell.textField.borderStyle = .none
            cell.textField.placeholder = placeholders[indexPath.row]
            cell.selectionStyle = .none
            return cell
            
        // Second section: Set Due Date
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskRepeatTableViewCell") as! AddTaskRepeatTableViewCell
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                cell.repeatLabel.text = "Due Date is".localized + "\(dateFormatter.string(from: dateDue))"
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 && isDueShow {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
                
                return cell
            } else {    // unnecessary code
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskRepeatTableViewCell") as! AddTaskRepeatTableViewCell
                cell.repeatLabel.text = "Due Date".localized
                cell.selectionStyle = .none
                return cell
            }
            
        // Third section: Turn on/off Notification
        } else if indexPath.section == 2 && (!isNotifShow || indexPath.row != 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskNotifTableViewCell") as! TaskNotifTableViewCell
            cell.notifSwitch.isOn = false
            cell.notifSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
            cell.notifLabel.text = "Remind me at ".localized
            cell.selectionStyle = .none
            return cell
            
        // Fourth section: set the Notification Time
        } else if datePickerIndexPath == indexPath && isNotifShow{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
            cell.notifDatePicker.addTarget(self, action: #selector(datePickerChanged), for: UIControl.Event.valueChanged)
            return cell
            
        // Fifth section: Set the Repetition of the Task
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskRepeatTableViewCell") as! AddTaskRepeatTableViewCell
            cell.repeatLabel.text = "Repeat the Task".localized
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 2 && isNotifShow && indexPath.row == 1) || (indexPath.section == 1 && isDueShow && indexPath.row == 1) {
            return 160.0
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {           // Title and Details
            return 2
        } else if section == 1 {    // Due
            return isDueShow ? 2 : 1
        } else if section == 2 {    // Notification Switch and Date
            return isNotifShow ? 2 : 1
        } else if section == 3{     // Repeat?
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Due Date Setting: Add the Date picker below the cell
        if indexPath.section == 1 && indexPath.row == 0 {
            if isDueShow {
                isDueShow = false
                tableView.deleteRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .none)
            }
            isDueShow = true
            tableView.insertRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
        }
        
        // Repetition Setting: Show up the SCL Alert View with buttons
        if indexPath.section == 3 && indexPath.row == 0 {
            let repeatDetails: SCLAlertView = SCLAlertView()
            
            repeatDetails.addButton("Daily".localized) {
                self.repeatInt = 0
                
            }
            
            repeatDetails.addButton("Weekly".localized) {
                self.repeatInt = 1
                
            }
            
            repeatDetails.addButton("Monthly".localized) {
                self.repeatInt = 2
                
            }
            
            repeatDetails.addButton("Yearly".localized) {
                self.repeatInt = 3
                
            }
            
            repeatDetails.addButton("Custom".localized) {
                self.repeatInt = 4
                
            }
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Due date saved
        if indexPath.section == 1 && indexPath.row == 0 {
            isDueShow = false
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! AddTaskDateTableViewCell
            dateDue = cell.notifDatePicker.date
            tableView.deleteRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .none)
        }
        // Notification saved
        else if indexPath.section == 2 && indexPath.row == 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! AddTaskDateTableViewCell
            notif = cell.notifDatePicker.date
        }
    }
    
    @objc func switchIsChanged (_ sender: Any) {
        if !isNotifShow {
            isNotifShow = true
            tableView.insertRows(at: [datePickerIndexPath ?? IndexPath(row: 1, section: 2)], with: .automatic)
        } else {
            isNotifShow = false
            tableView.deleteRows(at: [datePickerIndexPath ?? IndexPath(row: 1, section: 2)], with: .automatic)
        }
    }
    
    @objc func doneAdding (_ sender: Any) {
        _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, LabelID: labelID, Title: taskTitle, Due: dateDue, Detail: taskDetail, NotifDate: notif, isNotif: isNotifShow, isDone: false, isDeleted: false, isRepeat: true, dateToRepeat: repeatInt))
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TaskNotifTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.notifLabel.text = "Remind me at ".localized + "\(dateFormatter.string(from: notif))"
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }

}
