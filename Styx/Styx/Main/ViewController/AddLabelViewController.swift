//
//  AddLabelViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/28/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var labelTitle: String!
    var labelColorID: Int!
    
    var txtFieldTitle: SkyFloatingLabelTextField!
    
    var doneButton: UIBarButtonItem!
    
    let placeholders: Array<String> = ["Please type the title".localized]
    let titles: Array<String> = ["Title".localized]
    let emptyTitleAlert: String = "Title should not be empty.".localized

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
            ControlUtil.setSkyFloatingTextFieldColor(textField: cell.labelTitleTextField, placeholder: placeholders[indexPath.row], title: titles[indexPath.row])
            txtFieldTitle = cell.labelTitleTextField
            cell.labelTitleTextField.tag = 0
            txtFieldTitle.delegate = self
            cell.labelTitleTextField.addTarget(self, action: #selector(titleChanged(_:)), for: UIControl.Event.editingDidEnd)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLabelColorIDTableViewCell") as! AddLabelColorIDTableViewCell
            
            return cell
        }
    }
    
    @objc func titleChanged(_ textfield: SkyFloatingLabelTextField) {
        labelTitle = textfield.text
        if labelTitle.isEmpty {
            textfield.lineColor = UIColor.red
            textfield.errorColor = UIColor.red
            textfield.errorMessage = emptyTitleAlert
        }
    }

    @objc func doneAdding (_ sender: Any) {
        _ = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: labelTitle, ColorID: labelColorID))
        MainViewController.mainView.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

}
