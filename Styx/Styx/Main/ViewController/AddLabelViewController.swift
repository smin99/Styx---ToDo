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
    var labelTitle: String! = ""
    var labelColorID: Int!
    
    var txtFieldTitle: SkyFloatingLabelTextField!
    var buttonPressedBefore: UIButton!
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.tintColor = UIColor.white
        if section == 1 {
            let label = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 30))
            label.text = "Choose the color for label".localized
            label.textAlignment = .left
            headerView.addSubview(label)
//            headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        footerView.tintColor = UIColor.white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 108
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Choose the color for label".localized
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLabelTableViewCell") as! AddLabelTableViewCell
            ControlUtil.setSkyFloatingTextFieldColor(textField: cell.labelTitleTextField, placeholder: placeholders[indexPath.row], title: titles[indexPath.row])
            txtFieldTitle = cell.labelTitleTextField
            cell.labelTitleTextField.tag = 0
            txtFieldTitle.delegate = self
            cell.labelTitleTextField.addTarget(self, action: #selector(titleChanged(_:)), for: UIControl.Event.editingChanged)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLabelColorIDTableViewCell") as! AddLabelColorIDTableViewCell
            cell.selectionStyle = .none
            for button in cell.colorButtons {
                button.backgroundColor = UIColorForLabel.UIColorFromRGB(colorid: button.tag)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.clipsToBounds = true
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    @objc func buttonPressed(_ colorButton: UIButton) {
        if buttonPressedBefore != nil {
            buttonPressedBefore.layer.borderColor = UIColor.black.cgColor
            buttonPressedBefore.layer.borderWidth = 1
        }
        colorButton.layer.borderColor = UIColor.blue.cgColor
        colorButton.layer.borderWidth = 2
        buttonPressedBefore = colorButton
        self.labelColorID = colorButton.tag
        
        self.navigationController?.navigationBar.barTintColor = UIColorForLabel.UIColorFromRGB(colorid: colorButton.tag)
    }
    
    @objc func titleChanged(_ textfield: SkyFloatingLabelTextField) {
        labelTitle = textfield.text
        if labelTitle.isEmpty {
            textfield.lineColor = UIColor.red
            textfield.errorColor = UIColor.red
            textfield.errorMessage = emptyTitleAlert
        } else {
            ControlUtil.setSkyFloatingTextFieldColor(textField: textfield)
            textfield.errorMessage = ""
        }
    }

    @objc func doneAdding (_ sender: Any) {
        if labelTitle != "" {
            if labelColorID == nil {
                labelColorID = 0
            }
            let id = MainViewController.Database.UpsertLabel(label: Label(ID: 0, Title: labelTitle, ColorID: labelColorID))
            let label = Label(ID: id, Title: labelTitle, ColorID: labelColorID)
            MainViewController.mainView.labelList.append(label)
            SideMenuTableViewController.sideMenu.labelList.append(label)
            MainViewController.mainView.labelIndex = MainViewController.mainView.labelList.count - 1
            MainViewController.mainView.tableView.reloadData()
            SideMenuTableViewController.sideMenu.tableView.reloadData()
            self.navigationController?.popViewController(animated: true)
        } else {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddLabelTableViewCell
            cell.labelTitleTextField.lineColor = UIColor.red
            cell.labelTitleTextField.errorColor = UIColor.red
            cell.labelTitleTextField.errorMessage = emptyTitleAlert
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

}
