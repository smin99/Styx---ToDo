//
//  AddLabelViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/28/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var labelTitle: String!
    var labelColorID: Int!
    
    var doneButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAdding))
        self.navigationItem.rightBarButtonItem = doneButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLabelTableViewCell") as! AddLabelTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLabelColorIDTableViewCell") as! AddLabelColorIDTableViewCell
            
            return cell
        }
    }

    @objc func doneAdding (_ sender: Any) {
        _ = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: labelTitle, ColorID: labelColorID))
        MainViewController.mainView.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }

}
