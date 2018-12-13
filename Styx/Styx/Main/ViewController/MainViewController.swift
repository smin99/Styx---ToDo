//
//  MainViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/12/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let tasksNotDue = ["Review hw3", "Work on project", "Read chapter 3"]
    let taskDue = ["", ""]
    
    override func viewDidLoad() {
        print("View did load")
        super.viewDidLoad()
        
        
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
    
    public func numberOfSection(in tableView: UITableView) -> Int{
        return 1
    }
    
    

}
