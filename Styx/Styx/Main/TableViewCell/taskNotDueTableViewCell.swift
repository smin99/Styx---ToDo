//
//  ListTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/13/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class taskNotDueTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var timeLabel: UITextField!
    @IBOutlet weak var taskDoneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
