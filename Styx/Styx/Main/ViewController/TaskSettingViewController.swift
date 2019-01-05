//
//  TaskSettingViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 1/5/19.
//  Copyright © 2019 Min. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class TaskSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var isNotifShow: Bool! = false
    var isDueShow: Bool! = false
    var isRepeat: Bool! = false
    var notif: Date! = Date()
    var labelID: Int64!
    var taskTitle: String! = ""
    var taskDetail: String! = ""
    var dateDue: Date! = Date()
    var repeatInt: Int! = 0
    
    var dueDatePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 1)
    var datePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 2)
    
    var doneButton: UIBarButtonItem!
    
    var txtFieldTitle: SkyFloatingLabelTextField!
    var txtFieldDetails: SkyFloatingLabelTextField!
    
    let placeholders: Array<String> = ["Please type the title".localized, "Please type the details".localized]
    let titles: Array<String> = ["Title".localized, "Details".localized]
    let emptyTitleAlert: String = "Title should not be empty.".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
            ControlUtil.setSkyFloatingTextFieldColor(textField: cell.textField, placeholder: placeholders[indexPath.row], title: titles[indexPath.row])
            
            if indexPath.row == 0 {
                txtFieldTitle = cell.textField
                cell.textField.tag = 0
                txtFieldTitle.delegate = self
                cell.textField.addTarget(self, action: #selector(titleChanged(_:)), for: UIControl.Event.editingDidEnd)
            } else if indexPath.row == 1 {
                txtFieldDetails = cell.textField
                cell.textField.tag = 1
                txtFieldDetails.delegate = self
                cell.textField.addTarget(self, action: #selector(detailsChanged(_:)), for: UIControl.Event.editingDidEnd)
            }
            cell.selectionStyle = .none
            return cell
            
            // Second section: Set Due Date
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskRepeatTableViewCell") as! AddTaskRepeatTableViewCell
                cell.repeatLabel.text = "Due Date is".localized
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 && isDueShow {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
                cell.notifDatePicker.addTarget(self, action: #selector(dueDatePickerChanged), for: UIControl.Event.valueChanged)
                cell.notifDatePicker.locale = Locale.autoupdatingCurrent
                return cell
            } else {    // unnecessary code
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskRepeatTableViewCell") as! AddTaskRepeatTableViewCell
                cell.repeatLabel.text = "Due Date is".localized
                cell.selectionStyle = .none
                return cell
            }
            
            // Third section: Turn on/off Notification
        } else if indexPath.section == 2 && (!isNotifShow || indexPath.row != 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskNotifTableViewCell") as! TaskNotifTableViewCell
            cell.notifSwitch.isOn = false
            cell.notifSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)
            cell.notifLabel.text = "Remind me on ".localized
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
        } else if indexPath.section == 1 {
            return 60
        } else if indexPath.section == 2 && isNotifShow {
            return 120
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Due Date Setting: Add the Date picker below the cell
        if indexPath.section == 1 && indexPath.row == 0 {
            if isDueShow {
                isDueShow = false
                let cell = tableView.cellForRow(at: dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)) as! AddTaskDateTableViewCell
                cell.notifDatePicker.removeTarget(self, action: #selector(dueDatePickerChanged), for: UIControl.Event.valueChanged)
                cell.notifDatePicker.locale = Locale.autoupdatingCurrent
                
                tableView.deleteRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
                return
            }
            
            isDueShow = true
            tableView.insertRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! AddTaskDateTableViewCell
            cell.notifDatePicker.addTarget(self, action: #selector(dueDatePickerChanged), for: UIControl.Event.valueChanged)
        }
        
        // Repetition Setting: Show up the SCL Alert View with buttons
        if indexPath.section == 3 && indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! AddTaskRepeatTableViewCell
            
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Due date saved
        if indexPath.section == 1 && indexPath.row == 0 {
            isDueShow = false
            if tableView.cellForRow(at: IndexPath(row: 1, section: 1)) != nil {
                let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! AddTaskDateTableViewCell
                dateDue = cell.notifDatePicker.date
                tableView.deleteRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .none)
                let dateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! AddTaskRepeatTableViewCell
                dateCell.repeatLabel.text = "Due Date is ".localized + "\(ControlUtil.dateToString(date: dateDue))"
            }
        }
            // Notification saved
        else if indexPath.section == 2 && indexPath.row == 0 {
            //            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! AddTaskDateTableViewCell
            //            notif = cell.notifDatePicker.date
        }
    }
    
    @objc func switchIsChanged (_ sender: Any) {
        if !isNotifShow {
            isNotifShow = true
            tableView.insertRows(at: [datePickerIndexPath ?? IndexPath(row: 1, section: 2)], with: .automatic)
        } else {
            isNotifShow = false
            tableView.deleteRows(at: [datePickerIndexPath ?? IndexPath(row: 1, section: 2)], with: .automatic)
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TaskNotifTableViewCell
            cell.notifLabel.numberOfLines = 1
        }
    }
    
    @objc func doneAdding (_ sender: Any) {
        if self.taskTitle.isEmpty {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddTaskTableViewCell
            cell.textField.lineColor = UIColor.red
            cell.textField.errorColor = UIColor.red
            cell.textField.errorMessage = emptyTitleAlert
            return
        }
        _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, LabelID: labelID, Title: taskTitle, Due: dateDue, Detail: taskDetail, NotifDate: notif, isNotif: isNotifShow, isRepeat: isRepeat, dateToRepeat: repeatInt))
        MainViewController.mainView.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func titleChanged(_ textfield: SkyFloatingLabelTextField) {
        taskTitle = textfield.text
        if taskTitle.isEmpty {
            textfield.lineColor = UIColor.red
            textfield.errorColor = UIColor.red
            textfield.errorMessage = emptyTitleAlert
        } else {
            ControlUtil.setSkyFloatingTextFieldColor(textField: textfield)
            textfield.errorMessage = ""
        }
    }
    
    @objc func detailsChanged(_ textfield: UITextField) {
        taskDetail = textfield.text
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        notif = picker.date
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TaskNotifTableViewCell
        
        let dateString = ControlUtil.dateToString(date: notif)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 10
        
        let attrString = NSMutableAttributedString(string: cell.notifLabel.text!)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        cell.notifLabel.numberOfLines = 2
        cell.notifLabel.attributedText = attrString
        cell.notifLabel.text = "Remind me on ".localized + "\n \(dateString)"
        
    }
    
    @objc func dueDatePickerChanged(picker: UIDatePicker) {
        dateDue = picker.date
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! AddTaskRepeatTableViewCell
        
        let dateString = ControlUtil.dateToString(date: dateDue)
        cell.repeatLabel.text = "Due Date is ".localized + "\(dateString)"
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField.tag == 0 {
            textField.resignFirstResponder()
            if let nextResponder = tableView.viewWithTag(1) {
                nextResponder.becomeFirstResponder()
            }
        } else if textField.tag == 1 {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
