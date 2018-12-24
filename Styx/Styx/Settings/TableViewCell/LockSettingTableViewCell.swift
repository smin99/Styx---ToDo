//
//  LockSettingTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/24/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class LockSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
