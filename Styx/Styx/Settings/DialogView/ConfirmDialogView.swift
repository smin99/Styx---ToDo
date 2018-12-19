//
//  AlarmDialogView.swift
//  P1018
//
//  Created by khhwang on 23/10/2018.
//  Copyright © 2018 SnJ Mobile. All rights reserved.
//

import UIKit
import SwiftMessages
//import DLRadioButton

// Ask whether to delete the task or not
class ConfirmDialogView: MessageView {

    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var contentLabel2: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var yesAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    @IBAction func yesButtonAction() {
        yesAction?()
    }

    @IBAction func cancelButtonAction() {
        cancelAction?()
    }
    
    func initControl() {
        titleLabel2.text = "Delete Task".localized
        contentLabel2.text = "Do you want to delete this task? It will delete all included list items.".localized
        yesButton.setTitle("Delete".localized, for: .normal)
        cancelButton.setTitle("Cancel".localized, for: .normal)
    }
}
