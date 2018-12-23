//
//  SettingViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/22/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sections = [["Screen Lock".localized, "Delete Trash".localized, "Notification".localized],
                    ["Add review".localized, "Recommended Apps".localized, "Recommend to Friends".localized],
                    ["Open Source License".localized, "Version".localized]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
