//
//  ListTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/19/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var CompleteRadiobutton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
