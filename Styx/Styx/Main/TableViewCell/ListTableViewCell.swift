//
//  ListTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/19/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import DLRadioButton

class ListTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var taskTableViewController: TaskTableViewController?
    var checkItem: List!
    var checkIndex: Int!

    @IBOutlet weak var checkButton: DLRadioButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayTitle() {        
        if let index = titleTextField.defaultTextAttributes.index(forKey: NSAttributedString.Key.strikethroughStyle) {
            titleTextField.defaultTextAttributes.remove(at: index)
        }
        
        checkButton.isSelected = checkItem.isDone
        if !checkItem.Title.isEmpty {
            if checkItem.isDone {
                titleTextField.attributedText = checkItem.Title.strikeThrough()
                titleTextField.textColor = UIColor.gray
            } else {
                titleTextField.attributedText = checkItem.Title.normalAttribute()
                titleTextField.textColor = UIColor.black
            }
        } else {
            if checkItem.isDone {
                titleTextField.attributedText = "".strikeThrough()
            } else {
                titleTextField.attributedText = "".normalAttribute()
            }
        }
        
        deleteButton.isHidden = !isSelected
    }
    
    // Delete Button clicked at row
    @IBAction func deleteButtonClick(_ sender: Any) {
        taskTableViewController?.deleteCheckItem(item: checkItem)
        _ = MainViewController.Database.DeleteList(ID: checkItem.ID)
    }
    
    @IBAction func checkButtonClick(_ sender: DLRadioButton) {
        // Disable to complete empty list
        if checkItem.isDone == false && checkItem.Title.isEmpty {
            checkButton.isSelected = false
            return
        }
        
        checkButton.isSelected = !checkItem.isDone
        checkItem.isDone = checkButton.isSelected
        _ = MainViewController.Database.UpsertList(list: checkItem)
        
        if !checkItem.Title.isEmpty {
            if checkItem.isDone {
                titleTextField.attributedText = checkItem.Title.strikeThrough()
                titleTextField.textColor = UIColor.gray
                taskTableViewController?.listNotDone.remove(at: checkIndex)
                taskTableViewController?.listDone.append(checkItem)
            } else {
                titleTextField.attributedText = checkItem.Title.normalAttribute()
                titleTextField.textColor = UIColor.black
                if let index = titleTextField.defaultTextAttributes.index(forKey: NSAttributedString.Key.strikethroughStyle) {
                    titleTextField.defaultTextAttributes.remove(at: index)
                }
                taskTableViewController?.listDone.remove(at: checkIndex)
                taskTableViewController?.listNotDone.append(checkItem)
            }
            taskTableViewController?.tableView.reloadData()
        } else {
            if checkItem.isDone {
                titleTextField.attributedText = "".strikeThrough()
            } else {
                titleTextField.attributedText = "".normalAttribute()
                if let index = titleTextField.defaultTextAttributes.index(forKey: NSAttributedString.Key.strikethroughStyle) {
                    titleTextField.defaultTextAttributes.remove(at: index)
                }
            }
        }
    }
    
    @IBAction func titleBeginEditing(_ sender: Any) {
        deleteButton.isHidden = false
    }
    
    @IBAction func titleEndEditing(_ sender: Any) {
        deleteButton.isHidden = true
    }
    
    @IBAction func titleEditingChanged(_ sender: Any) {
        print("titleChanged: \(titleTextField.text ?? "")")
        checkItem.Title = titleTextField.text ?? ""
        if checkItem.Title.isEmpty {
            checkButton.isSelected = false
            checkItem.isDone = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        taskTableViewController?.nextCheckItem(item: checkItem)
        _ = MainViewController.Database.UpsertList(list: checkItem)
        return true
    }

}
