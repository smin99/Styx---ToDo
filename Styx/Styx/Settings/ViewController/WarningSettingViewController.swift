//
//  LockSettingViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/23/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class WarningSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let timeInterval = ["30 minutes before", "1 hour before", "3 hours before", "12 hours before", "1 day before", "3 days before", "a week before"]

    @IBOutlet weak var tableView: UITableView!
    
    var doneButton: UIBarButtonItem!
    var timeSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = doneButton

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 160
        } else {
            return 60
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeInterval.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeInterval[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeSelected = row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarningTableViewCell") as! WarningTableViewCell
            cell.titleLabel.text = "Warning sign time".localized
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarningDatePickerTableViewCell") as! WarningDatePickerTableViewCell
            cell.timePicker.dataSource = self
            cell.timePicker.delegate = self
            if AppDefaults.isKeyPresentInUserDefaults(key: "WarningTime") {
                cell.timePicker.selectRow(AppDefaults.getDefaultsInt(key: "WarningTime"), inComponent: 1, animated: true)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func doneEditing(_ sender: Any) {
        AppDefaults.setDefaultsInt(key: "WarningTime", value: timeSelected)
        navigationController?.popViewController(animated: true)
    }
}
