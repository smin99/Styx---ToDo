//
//  MainViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/12/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import EZLoadingActivity
import SwiftMessages
import SideMenu
import JJFloatingActionButton

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    static var Database: TaskDBProtocol!
    static var mainView: MainViewController!
    
    var labelList: Array<Label>!
    var taskList: Array<Task>!
    var listList: Array<List>!
    var imageList: Array<Image>!
        
    var isInitData: Bool = false
    
    // passed from side menu: if not given, set it to 0
    var labelIndex: Int = 0
    
    // two navigation bar buttons: Edit and Setting
    var editButton: UIBarButtonItem!
    var settingButton: UIBarButtonItem!
    
    var warningSign: UIImage!
    
    // add button
    var actionButton: JJFloatingActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
        
        // SideMenu Initialization
        SideMenuManager.default.menuPushStyle = .defaultBehavior
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = view.frame.width * 0.8
        if let sideMenu = storyboard?.instantiateViewController(withIdentifier: "leftSideMenu") {
            SideMenuManager.default.menuLeftNavigationController = sideMenu as? UISideMenuNavigationController
            
            SideMenuManager.default.menuAddPanGestureToPresent(toView: self.tableView)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.tableView)
        }
        
        // Add two bar buttons at right side of navigation bar
        editButton = UIBarButtonItem(image: UIImage(named: "TrashIcon"), style: .plain, target: self, action: #selector(tableEditing))
        settingButton = UIBarButtonItem(image: UIImage(named: "SettingIcon"), style: .plain, target: self, action: #selector(settingView))
        self.navigationItem.rightBarButtonItems = [settingButton, editButton]
        
        // JJFloatingActionButton for Adding Task
        actionButton = JJFloatingActionButton()
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        actionButton.buttonColor = UIColorForLabel.UIColorFromRGB(rgbValue: UInt(0x08BCB7))
        
        actionButton.addItem(title: "", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
                viewController.labelID = self.labelList[self.labelIndex].ID
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        // Designs
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will disappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isInitData {
            
            initNavigation()
            return
        }
        
        EZLoadingActivity.show("Loading...".localized, disableUI: true)
        DispatchQueue.global().async {
            
            self.labelList = MainViewController.Database.GetLabelList()
            self.taskList = MainViewController.Database.GetTaskList()
            self.listList = MainViewController.Database.GetListList()
            self.imageList = MainViewController.Database.GetImageList()
            
            // when labelList is empty, make a test case
            if self.labelList.count == 0 {
                
                /* first time to use the app: initialize empty label
                 _ = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: "New Label", ColorID: 0))
                 
                */
                
                _ = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: "Homework", ColorID: 0))
                let id1 = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: "Project", ColorID: 0))
                let id2 = MainViewController.Database.UpsertTask(task: Task(ID: 0, LabelID: id1, Title: "Chapter 3", Due: Date(), Detail: "", NotifDate: Date(), isNotif: false, isDone: false, isDeleted: false))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "34", isDone: false))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "35", isDone: true))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "36", isDone: false))
                _ = MainViewController.Database.UpsertList(list: List(ID: 0, TaskID: id2, Title: "37", isDone: false))
                _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, LabelID: id1, Title: "Chapter 5", Due: Date(), Detail: "", NotifDate: Date(), isNotif: false))
                _ = MainViewController.Database.UpsertTask(task: Task(ID: 0, LabelID: id1, Title: "Chapter 6", Due: Date(), Detail: "", NotifDate: Date(), isNotif: false))
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
                
                if self.labelList == nil {
                    self.tableView.reloadData()
                }
                
                if self.labelList == nil {
                    self.navigationController?.navigationBar.barTintColor = UIColorForLabel.UIColorFromRGB(colorid: 0)
                } else {
                    self.navigationController?.navigationBar.barTintColor = UIColorForLabel.UIColorFromRGB(colorid: self.labelList[self.labelIndex].ColorID)
                }
                
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                self.navigationItem.title = self.labelList[self.labelIndex].Title
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("View did disappear")
        stopAvoidingKeyboard()  // Stop changing the view size when keyboard disappear/appear
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if labelList == nil || labelList.count == 0 { return 0 }
        return labelList[labelIndex].taskList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // count the list completed and save it
        var numListCompleted = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell

        if !labelList[labelIndex].taskList.isEmpty {
            for list in labelList[labelIndex].taskList[indexPath.row].listList {
                if list.isDone { numListCompleted = numListCompleted + 1 }
            }
            
            cell.titleLabel.text = labelList[labelIndex].taskList[indexPath.row].Title
            cell.dueLabel.text = ControlUtil.dateToString(date: labelList[labelIndex].taskList[indexPath.row].Due)
        
            let progressFloat: Float = numListCompleted == 0 ? 0.0 : Float(Double(numListCompleted) / Double(labelList[labelIndex].taskList[indexPath.row].listList.count))
    //        print("\(numListCompleted)")
    //        print("\(Double(numListCompleted) / Double(labelList[labelIndex].taskList[indexPath.row].listList.count))")
            cell.taskProgressBar.progress = progressFloat
            cell.taskProgressPercentageLabel.text = String(format: "%.2f", progressFloat * 100) + " %"
            
            if !labelList[labelIndex].taskList[indexPath.row].isDone {
                warningSign = UIImage(named: "WarningIcon")
                cell.warningMark.titleLabel!.text = ""
                cell.warningMark.setImage(warningSign, for: .normal)
                cell.warningMark.tintColor = UIColorForLabel.UIColorFromRGB(rgbValue: UInt(0xF7CD4D))
    //            cell.warningMark.backgroundColor = UIColor.red
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskTableViewController") as? TaskTableViewController {
            viewController.taskTitle = labelList[labelIndex].taskList[indexPath.row].Title
            viewController.listForTask = labelList[labelIndex].taskList[indexPath.row].listList
            viewController.taskID = labelList[labelIndex].taskList[indexPath.row].ID
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // Edit Bar Button: Change into Editing mode
    @objc public func tableEditing(_ sender: Any) {
        if self.tableView.isEditing {
            editButton.image = UIImage(named: "TrashIcon")
        } else {
            editButton.image = UIImage(named: "CancelIcon")
        }
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    // Call Setting View Controller
    @objc func settingView(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Label Bar Button: Modally present side menu for labels
    @IBAction func labelSideMenu(_ sender: Any) {
        if let left = SideMenuManager.default.menuLeftNavigationController {
            present(left, animated: true, completion: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let view: ConfirmDialogView = try! SwiftMessages.viewFromNib()
            view.configureDropShadow()
            
            view.yesAction = {
                let id: Int64 = self.labelList[self.labelIndex].taskList[indexPath.row].ID
                
                var listIndex = self.listList.lastIndex(where: {$0.TaskID == id})
                while listIndex != nil {
                    self.listList.remove(at: listIndex!)
                    listIndex = self.listList.lastIndex(where: {$0.TaskID == id})
                }
                
                _ = MainViewController.Database.DeleteTask(id: id)
                self.taskList.remove(at: self.taskList.lastIndex(where: {$0.ID == id})!)
                self.labelList[self.labelIndex].taskList.remove(at: indexPath.row)
                tableView.reloadData()
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                SwiftMessages.hide()
            }
            
            view.cancelAction = {
                SwiftMessages.hide()
            }
            
            var config = SwiftMessages.defaultConfig
            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            config.duration = .forever
            config.presentationStyle = .center
            config.dimMode = .gray(interactive: true)
            view.initControl()
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    public func initNavigation () {
        if self.labelList == nil {
            self.navigationController?.navigationBar.barTintColor = UIColorForLabel.UIColorFromRGB(colorid: 0)
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColorForLabel.UIColorFromRGB(colorid: self.labelList[self.labelIndex].ColorID)
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = self.labelList[self.labelIndex].Title
    }
}
