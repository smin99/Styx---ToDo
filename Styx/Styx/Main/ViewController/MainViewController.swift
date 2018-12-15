//
//  MainViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/12/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    // Test case
    let label1 = Label(ID: 1, Title: "", ColorID: 1)//  (ID: 1, Title: "homework", ColorID: 1)
    let label2 = Label(ID: 2, Title: "project", ColorID: 4)
    let task1 = Task(Title: "Review hw3", Due: Date(timeIntervalSinceNow: 30000000), Notif: 1, LabelID: 1)  // case 1: task not due
    let task2 = Task(Title: "Work on project", Due: Date(timeIntervalSinceNow: 2000000), LabelID: 2)    // case 2: task not due
    let task3 = Task(Title: "Read chapter 3", Due: Date(timeIntervalSinceNow: -3000), LabelID: 1)   // case 3: task due
    let task4 = Task(Title: "Write journal", Due: Date(timeIntervalSinceNow: -1000), LabelID: 1)    // case 4: task due
    lazy var tasks: [Task] = [task1, task2, task3, task4]
    
    override func viewDidLoad() {
        print("View did load")
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
//        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: showEditing(sender: editBarButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will disappear")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear")
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("View did disappear")
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskNotDueTableViewCell", for: indexPath) as! taskNotDueTableViewCell
        
        //cell.pictureImageView.image = UIImage(named: "")
        cell.titleLabel.text = tasks[indexPath.row].Title
        cell.timeLabel.text = tasks[indexPath.row].Due.toString(dateformat: "mm-dd")
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskTableViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tableEditing(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
        
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Tasks to do"
//    }

}
