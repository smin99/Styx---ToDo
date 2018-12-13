//
//  taskDueTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class taskDueTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var taskDueDoneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
