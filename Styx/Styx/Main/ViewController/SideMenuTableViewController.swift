//
//  SideMenuTableViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/19/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import SwiftMessages
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
    static var sideMenu: SideMenuTableViewController!
    
    var labelList: Array<Label>!
    
    var editButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuTableViewController.sideMenu = self
        
        editButton = UIBarButtonItem(image: UIImage(named: "TrashIcon"), style: .plain, target: self, action: #selector(editMode))
        editButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = editButton
        
        addButton = UIBarButtonItem(image: UIImage(named: "AddIcon"), style: .plain, target: self, action: #selector(addLabel))
        addButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = addButton
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.labelList = MainViewController.mainView.labelList
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
        cell.titleLabel.text = labelList[indexPath.row].Title
        cell.openImageView.image = UIImage(named: "LabelIcon")
        cell.labelItem = labelList[indexPath.row]
        cell.openImageView.tintColor = UIColorForLabel.UIColorFromRGB(colorid: labelList[indexPath.row].ColorID)
//        cell.setColor()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MainViewController.mainView.labelIndex = indexPath.row
        MainViewController.mainView.tableView.reloadData()
        MainViewController.mainView.viewDidAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editMode(_ sender: Any) {
        if self.tableView.isEditing {
            editButton.image = UIImage(named: "TrashIcon")
        } else {
            editButton.image = UIImage(named: "CancelIcon")
        }
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    @IBAction func addLabel(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLabelViewController") as! AddLabelViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let view: ConfirmDialogView = try! SwiftMessages.viewFromNib()
            view.configureDropShadow()
            
            view.yesAction = {
                let labelID: Int64 = self.labelList[indexPath.row].ID
                
                for task in self.labelList[indexPath.row].taskList {
                    
                    for list in task.listList {
                        _ = MainViewController.Database.DeleteList(ID: list.ID)
                        MainViewController.mainView.listList.remove(at: MainViewController.mainView.listList.lastIndex(where: {$0.ID == list.ID})!)
                    }
                    _ = MainViewController.Database.DeleteTask(id: task.ID)
                    MainViewController.mainView.taskList.remove(at: MainViewController.mainView.taskList.lastIndex(where: {$0.ID == task.ID})!)
                }
                
                _ = MainViewController.Database.DeleteLabel(labID: labelID)
                self.labelList.remove(at: indexPath.row)
                MainViewController.mainView.labelList.remove(at: indexPath.row)
                if MainViewController.mainView.labelIndex == indexPath.row {
                    MainViewController.mainView.labelIndex = 0
                }
                tableView.reloadData()
                MainViewController.mainView.tableView.reloadData()
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
            
            view.titleLabel2.text = "Delete Label".localized
            view.contentLabel2.text = "Do you really want to delete this label? It will delete all tasks and items belonged to it.".localized
            SwiftMessages.show(config: config, view: view)
        }
    }

}
