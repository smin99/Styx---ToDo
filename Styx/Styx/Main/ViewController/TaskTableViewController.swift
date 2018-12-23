//
//  TaskTableViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var taskIndex: Int = 0
    var taskTitle: String = ""
    var taskListForLabel: Array<Task>!
    var listForTask: Array<List>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  taskTitle + " Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskListForLabel = MainViewController.mainView.labelList[MainViewController.mainView.labelIndex].taskList
        listForTask = taskListForLabel[taskIndex].listList
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listForTask.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell

        if listForTask[indexPath.row].isDone {
            cell.CompleteRadiobutton.setImage(UIImage(named: "RadioButtonComplete"), for: .normal)
        } else {
            cell.CompleteRadiobutton.setImage(UIImage(named: "RadioButtonIncomplete"), for: .normal)
        }
        cell.titleLabel.text = listForTask[indexPath.row].Title

        return cell
    }
    
    func deleteList(indexPath: IndexPath) {
        
    }
}
