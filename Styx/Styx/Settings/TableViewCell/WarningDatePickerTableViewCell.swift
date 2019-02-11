//
//  WarningDatePickerTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 2/9/19.
//  Copyright © 2019 Min. All rights reserved.
//

import UIKit

class WarningDatePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
