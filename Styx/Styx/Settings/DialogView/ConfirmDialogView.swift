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

// 메모 내용이 변경된 후 뒤로 버튼으로 벗어 나고자 할때 저장할지 묻는 대화상자
class ConfirmDialogView: MessageView {

    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var contentLabel2: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var noAction: (() -> Void)?
    var yesAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    @IBAction func noButtonAction() {
        noAction?()
    }
    
    @IBAction func yesButtonAction() {
        yesAction?()
    }

    @IBAction func cancelButtonAction() {
        cancelAction?()
    }
    
    func initControl() {
        titleLabel2.text = "Delete Task".localized
        contentLabel2.text = "Do you want to delete this task? It will delete all included list items.".localized
        noButton.setTitle("No".localized, for: .normal)
        yesButton.setTitle("Yes".localized, for: .normal)
        cancelButton.setTitle("Cancel".localized, for: .normal)
    }
}
