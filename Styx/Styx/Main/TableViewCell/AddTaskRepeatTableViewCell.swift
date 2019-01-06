//
//  AddTaskRepeatTableViewCell.swift
//  Styx
//
//  Created by HwangSeungmin on 12/29/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class AddTaskRepeatTableViewCell: UITableViewCell {
    
    @IBOutlet var dateButtons: [UIButton]!
    @IBOutlet weak var allWeekButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
