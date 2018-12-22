//
//  LabelTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/16/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var openImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var labelItem: Label!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
