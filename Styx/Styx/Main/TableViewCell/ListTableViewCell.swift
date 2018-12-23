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
            } else {
                titleTextField.attributedText = checkItem.Title.normalAttribute()
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
    
    // Row 삭제 버튼 클릭 -
    @IBAction func deleteButtonClick(_ sender: Any) {
        taskTableViewController?.deleteCheckItem(item: checkItem)
    }
    
    @IBAction func checkButtonClick(_ sender: DLRadioButton) {
        // 빈 문자열이면 완료 표시를 할 수 없게 설정 한다.
        if checkItem.isDone == false && checkItem.Title.isEmpty {
            checkButton.isSelected = false
            return
        }
        
        checkButton.isSelected = !checkItem.isDone
        checkItem.isDone = checkButton.isSelected
        if !checkItem.Title.isEmpty {
            if checkItem.isDone {
                titleTextField.attributedText = checkItem.Title.strikeThrough()
            } else {
                titleTextField.attributedText = checkItem.Title.normalAttribute()
                if let index = titleTextField.defaultTextAttributes.index(forKey: NSAttributedString.Key.strikethroughStyle) {
                    titleTextField.defaultTextAttributes.remove(at: index)
                }
            }
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
        return true
    }

}
