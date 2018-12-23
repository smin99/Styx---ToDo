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
                cell.CompleteRadiobutton.setImage(UIImage(named: "RadioButtonComplete"), for: .normal)
            } else {
                cell.CompleteRadiobutton.setImage(UIImage(named: "RadioButtonIncomplete"), for: .normal)
            }
            cell.titleLabel.text = listForTask[indexPath.row].Title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCompletedListTableViewCell", for: indexPath) as! ShowCompletedListTableViewCell
            return cell
        }
    }
    
    func deleteList(indexPath: IndexPath) {
        
    }
}
