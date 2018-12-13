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
    let task1 = Task(Title: "Review hw3", Due: Date(timeIntervalSinceNow: 30000000), Notif: Date(timeIntervalSinceNow: 29000000), Label: ["homework", "math"])  // case 1: task not due
    let task2 = Task(Title: "Work on project", Due: Date(timeIntervalSinceNow: 2000000), Notif: Date(timeIntervalSinceNow: 1900000), Label: ["project", "cs"])    // case 2: task not due
    let task3 = Task(Title: "Read chapter 3", Due: Date(timeIntervalSinceNow: -3000), Notif: Date(timeIntervalSinceNow: -2000), Label: ["homework", "english"])   // case 3: task due
    let task4 = Task(Title: "Write journal", Due: Date(timeIntervalSinceNow: -1000), Notif: Date(timeIntervalSinceNow: -500), Label: ["homework", "english"])    // case 4: task due
    lazy var tasks: [Task] = [task1, task2, task3, task4]
    
    override func viewDidLoad() {
        print("View did load")
        super.viewDidLoad()
        
        
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
        print("View did appear")
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
    
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Tasks to do"
//    }

}
