//
//  AddTaskViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/28/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isNotifShow: Bool! = false
    var isDueShow: Bool! = false
    var isRepeat: Bool! = false
    var notif: Date! = Date()
    var labelID: Int64!
    var taskTitle: String! = ""
    var taskDetail: String! = ""
    var dateDue: Date! = Date()
    var repeatString: String! = ""
    var taskID: Int64! = 0
    var isEditingPage: Bool! = false
    
    var dueDatePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 1)
    var datePickerIndexPath: IndexPath? = IndexPath(row: 1, section: 2)
    
    var doneButton: UIBarButtonItem!
    
    var txtFieldTitle: SkyFloatingLabelTextField!
    var txtFieldDetails: SkyFloatingLabelTextField!
    
    var dateButtonsSelected: [Bool]! = []
    
    let placeholders: Array<String> = ["Please type the title".localized, "Please type the details".localized]
    let titles: Array<String> = ["Title".localized, "Details".localized]
    let emptyTitleAlert: String = "Title should not be empty.".localized
    
    let dateButtonColor: UIColor = UIColorForLabel.UIColorFromRGB(colorid: 0)
    let highlightedColor: UIColor = UIColorForLabel.UIColorFromRGB(colorid: 9)
    let clearColor: UIColor = UIColor.clear
    
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
                // responsive saving
                cell.textField.addTarget(self, action: #selector(titleChanged(_:)), for: UIControl.Event.editingChanged)
                
                // for editing existing task
                if isEditingPage {
                    cell.textField.text = self.taskTitle
                }
            } else if indexPath.row == 1 {
                txtFieldDetails = cell.textField
                cell.textField.tag = 1
                txtFieldDetails.delegate = self
                cell.textField.addTarget(self, action: #selector(detailsChanged(_:)), for: UIControl.Event.editingDidEnd)
                
                if isEditingPage {
                    cell.textField.text = self.taskDetail
                }
            }
            cell.selectionStyle = .none
            return cell
            
        // Second section: Set Due Date
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDueTableViewCell") as! AddTaskDueTableViewCell
                cell.dueLabel.text = "Due Date is".localized
                cell.selectionStyle = .none
                
                if isEditingPage {
                    cell.dueLabel.text = "Due Date is ".localized + "\(ControlUtil.dateToString(date: self.dateDue))"
                }
                return cell
            } else if indexPath.row == 1 && isDueShow {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
                cell.notifDatePicker.addTarget(self, action: #selector(dueDatePickerChanged), for: UIControl.Event.valueChanged)
                cell.notifDatePicker.locale = Locale.autoupdatingCurrent
                
                if isEditingPage {
                    cell.notifDatePicker.date = self.dateDue
                }
                return cell
            } else {    // unnecessary code
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDueTableViewCell") as! AddTaskDueTableViewCell
                cell.dueLabel.text = "Due Date is".localized
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

            if isEditingPage {
                cell.notifSwitch.isOn = self.isNotifShow
                cell.notifLabel.numberOfLines = 2
                cell.notifLabel.text = "Remind me on ".localized + "\n \(ControlUtil.dateToString(date: self.notif))"
            }
            return cell
            
        // Fourth section: set the Notification Time
        } else if datePickerIndexPath == indexPath && isNotifShow{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskDateTableViewCell") as! AddTaskDateTableViewCell
            cell.notifDatePicker.addTarget(self, action: #selector(datePickerChanged), for: UIControl.Event.valueChanged)
            
            if isEditingPage {
                cell.notifDatePicker.date = self.notif
            }
            return cell
            
        // Fifth section: Set the Repetition of the Task
        } else {
            
            // cell with series of buttons: 0 for Sunday, 1 for Monday, 2 for Tuesday, 3 for Wednesday, 4 for Thursday, 5 for Friday,
            // 6 for Saturday, 7 for all dates, 8 for Monthly, 9 for Yearly
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskRepeatTableViewCell") as! AddTaskRepeatTableViewCell
            
            let dates: [String] = ["Sun".localized, "M".localized, "T".localized, "W".localized, "Thu".localized, "F".localized, "Sat".localized]
            
            // date buttons
            for tag in 0 ..< cell.dateButtons.count {
                cell.dateButtons[tag].setTitle(dates[tag], for: .normal)
                cell.dateButtons[tag].setTitleColor(dateButtonColor, for: .normal)
                cell.dateButtons[tag].showsTouchWhenHighlighted = true
//                cell.dateButtons[tag].setTitleColor(highlightedColor, for: .normal)
                cell.dateButtons[tag].layer.cornerRadius = 15
                cell.dateButtons[tag].layer.borderColor = dateButtonColor.cgColor
                cell.dateButtons[tag].layer.borderWidth = 1
                cell.dateButtons[tag].addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
                dateButtonsSelected.append(false)
            }
            
            cell.allWeekButton.setImage(UIImage(named: "CheckIcon"), for: .normal)
            cell.allWeekButton.tintColor = dateButtonColor
            cell.allWeekButton.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
            cell.allWeekButton.setTitle("", for: .normal)
            dateButtonsSelected.append(false)
            
            // Monthly & Yearly button : 8, 9
            cell.monthlyButton.setTitle("Monthly".localized, for: .normal)
            cell.monthlyButton.setTitleColor(dateButtonColor, for: .normal)
            cell.monthlyButton.setTitleColor(highlightedColor, for: .highlighted)
            cell.monthlyButton.showsTouchWhenHighlighted = true
            cell.monthlyButton.layer.borderWidth = 1
            cell.monthlyButton.layer.borderColor = dateButtonColor.cgColor
            cell.monthlyButton.layer.cornerRadius = 15
            cell.monthlyButton.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
            dateButtonsSelected.append(false)
            
            cell.yearlyButton.setTitle("Yearly".localized, for: .normal)
            cell.yearlyButton.setTitleColor(dateButtonColor, for: .normal)
            cell.yearlyButton.setTitleColor(highlightedColor, for: .highlighted)
            cell.yearlyButton.showsTouchWhenHighlighted = true
            cell.yearlyButton.layer.borderWidth = 1
            cell.yearlyButton.layer.borderColor = dateButtonColor.cgColor
            cell.yearlyButton.layer.cornerRadius = 15
            cell.yearlyButton.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
            dateButtonsSelected.append(false)
            
            if isEditingPage {
                
                let repeatDates: [String]! = self.repeatString.components(separatedBy: ",")
                var repeatTags: [Int]! = []
                for date in repeatDates {
                    if date != "" {
                        repeatTags.append(Int(date)!)
                    }
                }
                
                for tag in 0...9 {
                    
                    if repeatTags.count != 0 && tag == repeatTags[0] {
                        
                        repeatTags.remove(at: 0)
                        dateButtonsSelected[tag] = true
                        if tag < 6 {
                            cell.dateButtons[tag].backgroundColor = highlightedColor
                        } else if tag == 8 {
                            cell.monthlyButton.backgroundColor = highlightedColor
                        } else if tag == 9 {
                            cell.yearlyButton.backgroundColor = highlightedColor
                        }
                    }
                }
                
            }
            
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 2 && isNotifShow && indexPath.row == 1) || (indexPath.section == 1 && isDueShow && indexPath.row == 1) {
            return 160.0
        } else if indexPath.section == 1 {
            return 60
        } else if indexPath.section == 2 && isNotifShow {   // when expanded
            return 120
        } else if indexPath.section == 3 {
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
                
                if isEditingPage {
                    cell.notifDatePicker.date = self.dateDue
                }
                
                tableView.deleteRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
                return
            }
            
            isDueShow = true
            tableView.insertRows(at: [dueDatePickerIndexPath ?? IndexPath(row: 1, section: 1)], with: .automatic)
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! AddTaskDateTableViewCell
            cell.notifDatePicker.addTarget(self, action: #selector(dueDatePickerChanged), for: UIControl.Event.valueChanged)
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
                let dateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! AddTaskDueTableViewCell
                dateCell.dueLabel.text = "Due Date is ".localized + "\(ControlUtil.dateToString(date: dateDue))"
            }
        }
        // Notification saved
        else if indexPath.section == 2 && indexPath.row == 0 {
//            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! AddTaskDateTableViewCell
//            notif = cell.notifDatePicker.date
        }
    }
    
    // Called when date button is pressed
    @objc func dateButtonPressed (_ dateButton: UIButton) {
        print(dateButton.tag)
        // certain date
        if dateButton.tag < 7 {
            if dateButtonsSelected[dateButton.tag] {
                dateButtonsSelected[dateButton.tag] = false
                dateButton.backgroundColor = clearColor
//                dateButton.layer.borderColor = dateButtonColor.cgColor
            } else {
                dateButtonsSelected[dateButton.tag] = true
                dateButton.backgroundColor = highlightedColor
                weekDate(changeValue: false)
//                dateButton.layer.borderColor = highlightedColor.cgColor
//                self.repeatString = dateButton.tag.toDateString(dateString: self.repeatString)
            }
        }
        // all dates
        else if dateButton.tag == 7 {
            datesButton(changeValue: true)
        }
        // monthly & yearly
        else if dateButton.tag >= 8 {
            if dateButtonsSelected[dateButton.tag] {
                dateButtonsSelected[dateButton.tag] = false
                dateButton.backgroundColor = clearColor
            } else {
                dateButtonsSelected[dateButton.tag] = true
                datesButton(changeValue: false)
                dateButton.backgroundColor = highlightedColor
            }
        }
    }
    
    // Clear monthly/yearly buttons
    func weekDate(changeValue: Bool) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AddTaskRepeatTableViewCell
        if cell.monthlyButton.backgroundColor != clearColor {
            cell.monthlyButton.backgroundColor = clearColor
            self.dateButtonsSelected[8] = false
        }
        if cell.yearlyButton.backgroundColor != clearColor {
            cell.yearlyButton.backgroundColor = clearColor
            self.dateButtonsSelected[9] = false
        }
    }
    
    // When the button for all days OR monthly/yearly is clicked --> clear or highlight all dates buttons
    func datesButton(changeValue: Bool) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AddTaskRepeatTableViewCell
        let color = changeValue ? highlightedColor : clearColor
        for tag in 0...6 {
            cell.dateButtons[tag].backgroundColor = color
            self.dateButtonsSelected[tag] = changeValue
        }
        if cell.monthlyButton.backgroundColor != clearColor {
            cell.monthlyButton.backgroundColor = clearColor
            self.dateButtonsSelected[8] = false
        }
        if cell.yearlyButton.backgroundColor != clearColor {
            cell.yearlyButton.backgroundColor = clearColor
            self.dateButtonsSelected[9] = false
        }
    }
    
    
    // Switch for the Reminder (Notification)
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
    
    // Tapping the "Done" button for saving
    @objc func doneAdding (_ sender: Any) {
        if self.taskTitle.isEmpty {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddTaskTableViewCell
            cell.textField.lineColor = UIColor.red
            cell.textField.errorColor = UIColor.red
            cell.textField.errorMessage = emptyTitleAlert
            return
        }
        
        var repeatDates: [Int]! = []
        var const: Int = 0
        for isDate in dateButtonsSelected {
            if isDate {
                repeatDates.append(const)
            }
            const = const + 1
        }
        repeatString = ControlUtil.arrayToString(dates: repeatDates)
        
        _ = MainViewController.Database.UpsertTask(task: Task(ID: taskID, LabelID: labelID, Title: taskTitle, Due: dateDue, Detail: taskDetail, NotifDate: notif, isNotif: isNotifShow, isRepeat: isRepeat, dateToRepeat: repeatString))
        MainViewController.mainView.viewDidAppear(true)
        MainViewController.mainView.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    // Each time when the title is changed; If the title is empty, change the color and display the error message
    @objc func titleChanged(_ textfield: SkyFloatingLabelTextField) {
        self.taskTitle = textfield.text
        if taskTitle.isEmpty {
            textfield.lineColor = UIColor.red
            textfield.errorColor = UIColor.red
            textfield.errorMessage = emptyTitleAlert
        } else {
            ControlUtil.setSkyFloatingTextFieldColor(textField: textfield)
            textfield.errorMessage = ""
        }
    }
    
    // Save when details ended editing
    @objc func detailsChanged(_ textfield: UITextField) {
        taskDetail = textfield.text
    }
    
    // When the date picker for notification changed
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
    
    // When the date picker for due date has changed
    @objc func dueDatePickerChanged(picker: UIDatePicker) {
        dateDue = picker.date
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! AddTaskDueTableViewCell
        
        let dateString = ControlUtil.dateToString(date: dateDue)
        cell.dueLabel.text = "Due Date is ".localized + "\(dateString)"
    }
    
    // Changing index path to insert date picker for date picker
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    // Allow closing keyboards when clicked enter
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
