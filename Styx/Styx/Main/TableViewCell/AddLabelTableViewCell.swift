//
//  AddLabelTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/27/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddLabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitleTextField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
