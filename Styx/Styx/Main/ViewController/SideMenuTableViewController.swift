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
    
    var labelList: Array<Label>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.openImageView.image = UIImage(named: labelList[indexPath.row].isOpened ? "LabelOpenIcon" : "LabelCloseIcon")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MainViewController.mainView.labelIndex = indexPath.row
    }
    
    @IBAction func editMode(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let view: ConfirmDialogView = try! SwiftMessages.viewFromNib()
            view.configureDropShadow()
            
            view.yesAction = {
                let labelID: Int64 = self.labelList[indexPath.row].ID
                _ = MainViewController.Database.DeleteLabel(labID: labelID)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                SwiftMessages.hide()
                tableView.reloadData()
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

}
